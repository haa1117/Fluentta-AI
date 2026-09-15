const { onRequest } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const {
  CHAT_MODEL,
  CHAT_TEMPERATURE,
  CHAT_MAX_TOKENS,
  buildTutorMessages,
  parseTutorResponse,
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
