const { onRequest } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const {
  CHAT_MODEL,
  CHAT_TEMPERATURE,
  CHAT_MAX_TOKENS,
  LANGUAGE_NAMES,
  buildTutorMessages,
  parseTutorResponse,
  extractJsonObject,
  normaliseLanguage,
} = require("./aiTutor");
const { detectCrisisSignal, crisisResponse } = require("./safety");

setGlobalOptions({
  region: "us-central1",
  maxInstances: 10,
});

// Literal model for pronunciation — we want the raw phonetic transcription,
// warts and all, not a "helpful" auto-corrected one.
const WHISPER_MODEL = process.env.OPENAI_WHISPER_MODEL || "whisper-1";
// Conversational speech (chat voice mode) — newer model, much better on
// accented / non-native English, and it may tidy small disfluencies (fine here).
const TRANSCRIBE_MODEL =
  process.env.OPENAI_TRANSCRIBE_MODEL || "gpt-4o-mini-transcribe";
// gpt-4o-mini mixes up Urdu (Perso-Arabic) and Hindi (Devanagari) far more
// often than the full model — for this one language, worth the extra cost
// to actually get the right script instead of retrying a weaker model.
const URDU_TRANSLATE_MODEL = process.env.OPENAI_URDU_TRANSLATE_MODEL || "gpt-4o";

const requestOptions = {
  secrets: ["OPENAI_API_KEY"],
  cors: true,
  timeoutSeconds: 60,
  invoker: "public",
};

// Reserved warm instances for the chat function. Defaults to 0 (scale to zero,
// no idle cost) — fine for testing, but the first call after ~15 min idle takes
// 2–8s to cold start. For production, set FUNCTIONS_MIN_INSTANCES=1 in
// functions/.env (costs ~$2.88/month for one 256MB instance kept warm).
const CHAT_MIN_INSTANCES = Number(process.env.FUNCTIONS_MIN_INSTANCES ?? 0);

async function transcribeAudio({ audioBase64, mimeType, filename, model, prompt }) {
  const audioBuffer = Buffer.from(String(audioBase64 || "").trim(), "base64");
  if (audioBuffer.length < 64) {
    const error = new Error("Audio is empty");
    error.status = 400;
    throw error;
  }
  if (audioBuffer.length > 8 * 1024 * 1024) {
    const error = new Error("Audio is too large");
    error.status = 413;
    throw error;
  }

  const form = new FormData();
  form.append(
    "file",
    new Blob([new Uint8Array(audioBuffer)], { type: mimeType || "audio/mp4" }),
    filename || "speech.m4a",
  );
  form.append("model", model);
  form.append("language", "en");
  form.append("response_format", "json");
  if (prompt) form.append("prompt", prompt);

  const openaiRes = await fetch(
    "https://api.openai.com/v1/audio/transcriptions",
    {
      method: "POST",
      headers: { Authorization: `Bearer ${openaiKey()}` },
      body: form,
    },
  );
  const openaiJson = await openaiRes.json();
  if (!openaiRes.ok) {
    const error = new Error(
      openaiJson.error?.message || "Transcription failed",
    );
    error.status = 502;
    throw error;
  }
  return String(openaiJson.text || "").trim();
}

function json(res, status, body) {
  res.status(status).json(body);
}

function getAuth() {
  const admin = require("firebase-admin");
  if (admin.apps.length === 0) {
    admin.initializeApp();
  }
  return admin.auth();
}

async function requireUser(req) {
  const header = req.headers.authorization || "";
  const match = header.match(/^Bearer (.+)$/i);
  if (!match) {
    const error = new Error("Missing auth token");
    error.status = 401;
    throw error;
  }
  try {
    return await getAuth().verifyIdToken(match[1]);
  } catch (_) {
    const error = new Error("Invalid auth token");
    error.status = 401;
    throw error;
  }
}

function openaiKey() {
  const key = process.env.OPENAI_API_KEY;
  if (!key) {
    const error = new Error("OpenAI API key is not configured");
    error.status = 500;
    throw error;
  }
  return key;
}

function readJsonBody(req) {
  if (req.body && typeof req.body === "object") return req.body;
  if (typeof req.body === "string" && req.body.length > 0) {
    return JSON.parse(req.body);
  }
  return {};
}

exports.tutorChat = onRequest(
  { ...requestOptions, minInstances: CHAT_MIN_INSTANCES },
  async (req, res) => {
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }
  if (req.method !== "POST") {
    json(res, 405, { error: "Method not allowed" });
    return;
  }

  try {
    await requireUser(req);
    const body = readJsonBody(req);
    const userText = String(body.userText || "").trim();
    if (!userText) {
      json(res, 400, { error: "userText is required" });
      return;
    }

    // Deterministic safety net — never depend on the model alone to handle a
    // crisis message. Short-circuits before any OpenAI call. See safety.js.
    if (detectCrisisSignal(userText)) {
      json(res, 200, crisisResponse());
      return;
    }

    const messages = buildTutorMessages({
      userText,
      history: body.history,
      cefrLevel: body.cefrLevel,
      goal: body.goal,
      nativeLanguage: body.nativeLanguage,
    });

    const openaiRes = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${openaiKey()}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: CHAT_MODEL,
        temperature: CHAT_TEMPERATURE,
        max_tokens: CHAT_MAX_TOKENS,
        response_format: { type: "json_object" },
        messages,
      }),
    });

    const openaiJson = await openaiRes.json();
    if (!openaiRes.ok) {
      json(res, 502, {
        error: openaiJson.error?.message || "OpenAI chat failed",
      });
      return;
    }

    const content = openaiJson.choices?.[0]?.message?.content || "";
    json(res, 200, parseTutorResponse(content, userText));
  } catch (error) {
    json(res, error.status || 500, { error: error.message || "tutorChat failed" });
  }
  },
);

// Translates a vocabulary word's meaning + example sentence into the
// learner's app language, on demand — the bundled lesson content is
// English-only, so this is a lightweight per-tap translation, not part of
// the tutor conversation.
exports.translateVocabulary = onRequest(requestOptions, async (req, res) => {
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }
  if (req.method !== "POST") {
    json(res, 405, { error: "Method not allowed" });
    return;
  }

  try {
    await requireUser(req);
    const body = readJsonBody(req);
    const meaning = String(body.meaning || "").trim();
    const example = String(body.example || "").trim();
    const language = normaliseLanguage(body.targetLanguage);

    if (!meaning && !example) {
      json(res, 400, { error: "meaning or example is required" });
      return;
    }
    if (!language) {
      json(res, 400, {
        error: `targetLanguage must be one of: ${Object.keys(LANGUAGE_NAMES).join(", ")}`,
      });
      return;
    }

    let result = await translateOnce(meaning, example, language);

    // Urdu and Hindi are close enough (Hindustani) that the model sometimes
    // defaults to Devanagari script for "Urdu" — detect that and retry with
    // an even more explicit instruction rather than silently shipping the
    // wrong script. Each retry replaces `result`, so if every attempt still
    // comes back wrong we ship the *strongest-worded* attempt, not the
    // first (weakest) one.
    for (
      let attempt = 0;
      language === "Urdu" && containsDevanagari(result) && attempt < 2;
      attempt++
    ) {
      result = await translateOnce(meaning, example, language, {
        forceUrduScript: true,
      });
    }

    json(res, 200, result);
  } catch (error) {
    json(res, error.status || 500, {
      error: error.message || "translateVocabulary failed",
    });
  }
});

function containsDevanagari(fields) {
  const devanagari = /[ऀ-ॿ]/;
  return devanagari.test(fields.meaning) || devanagari.test(fields.example);
}

async function translateOnce(meaning, example, language, opts = {}) {
  const scriptGuidance =
    language === "Urdu"
      ? opts.forceUrduScript
        ? `\n\nCRITICAL: Your previous attempt used Devanagari script, which ` +
          `is WRONG. Urdu is written in the Perso-Arabic script (the same ` +
          `alphabet as Persian/Arabic, read right-to-left, e.g. "معنی", ` +
          `"مثال"). Do NOT use Devanagari (e.g. "अर्थ") under any ` +
          `circumstances — that is Hindi, a different language and script.`
        : `Urdu is written in the Perso-Arabic script (right-to-left, e.g. ` +
          `"معنی" not "अर्थ"). Never use Devanagari script — that is ` +
          `Hindi, a different language, even though the spoken languages ` +
          `sound similar.`
      : "";

  const model = language === "Urdu" ? URDU_TRANSLATE_MODEL : CHAT_MODEL;

  const openaiRes = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${openaiKey()}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model,
      // Deterministic for Urdu — script consistency matters more than
      // phrasing variety for a one-word/one-sentence gloss.
      temperature: language === "Urdu" ? 0 : 0.2,
      max_tokens: 300,
      response_format: { type: "json_object" },
      messages: [
        {
          role: "system",
          content:
            `Translate the given English vocabulary "meaning" and ` +
            `"example" fields into ${language}, for a learner studying ` +
            `English. Keep translations short and natural, matching the ` +
            `register of the English text.${scriptGuidance} Reply with ` +
            `ONLY minified JSON: {"meaning":"...","example":"..."} — ` +
            `translate only the fields that were provided; use "" for one ` +
            `that wasn't.`,
        },
        {
          role: "user",
          content: JSON.stringify({ meaning, example }),
        },
      ],
    }),
  });

  const openaiJson = await openaiRes.json();
  if (!openaiRes.ok) {
    const error = new Error(openaiJson.error?.message || "OpenAI translate failed");
    error.status = 502;
    throw error;
  }

  const content = openaiJson.choices?.[0]?.message?.content || "";
  let parsed;
  try {
    parsed = extractJsonObject(content);
  } catch (_) {
    parsed = {};
  }

  return {
    meaning: String(parsed.meaning || "").trim(),
    example: String(parsed.example || "").trim(),
  };
}

// Free-form speech transcription for the chat's voice mode.
exports.transcribe = onRequest(requestOptions, async (req, res) => {
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return;
  }
  if (req.method !== "POST") {
    json(res, 405, { error: "Method not allowed" });
    return;
  }

  try {
    await requireUser(req);
    const body = readJsonBody(req);
    const transcript = await transcribeAudio({
      audioBase64: body.audioBase64,
      mimeType: body.mimeType,
      filename: body.filename,
      model: TRANSCRIBE_MODEL,
      prompt:
        "The speaker is practising conversational English as a second " +
        "language. Transcribe what they say in English.",
    });
    json(res, 200, { transcript });
  } catch (error) {
    json(res, error.status || 500, {
      error: error.message || "transcribe failed",
    });
  }
});

exports.assessPronunciation = onRequest(
  {
    ...requestOptions,
    memory: "512MiB",
  },
  async (req, res) => {
    if (req.method === "OPTIONS") {
      res.status(204).send("");
      return;
    }
    if (req.method !== "POST") {
      json(res, 405, { error: "Method not allowed" });
      return;
    }

    try {
      await requireUser(req);
      const body = readJsonBody(req);
      if (!String(body.audioBase64 || "").trim()) {
        json(res, 400, { error: "audioBase64 is required" });
        return;
      }

      const transcript = await transcribeAudio({
        audioBase64: body.audioBase64,
        mimeType: body.mimeType,
        filename: body.filename,
        model: WHISPER_MODEL,
      });

      json(res, 200, {
        transcript,
        expectedPhrase: String(body.expectedPhrase || "").trim(),
      });
    } catch (error) {
      json(res, error.status || 500, {
        error: error.message || "assessPronunciation failed",
      });
    }
  },
);
