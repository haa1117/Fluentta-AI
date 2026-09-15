/**
 * aiTutor.js — the "brain" behind Fluenta's AI English teacher.
 *
 * Fluenta is an English tutor: every learner is a non‑native speaker who wants
 * to get better at English. The pedagogy here follows what modern AI
 * English‑learning apps (e.g. Learna) do well:
 *
 *   1. Hold a real, flowing conversation — never an interrogation or a quiz.
 *   2. Comprehensible input: answer at the learner's level, then stretch it
 *      one small step further ("i + 1").
 *   3. Correct gently and ONE thing at a time, with a short plain‑language
 *      reason. Never dump a list of errors.
 *   4. Always hand the conversation back with a follow‑up question so the
 *      learner keeps producing English.
 *   5. Be goal‑aware — a learner practising for work needs different words and
 *      register than one practising for travel or an exam.
 *   6. Stay warm and encouraging. Confidence is half the battle.
 *
 * Scope: this powers Fluenta's "Open Chat Practice" only — a free, open‑ended
 * conversation. The scripted roleplay scenarios are a separate feature that
 * runs off bundled content and never touches this function.
 *
 * The module is transport‑agnostic: it only builds the OpenAI `messages`
 * array and parses the model's JSON reply. index.js wires it to HTTP.
 */

const CHAT_MODEL = process.env.OPENAI_CHAT_MODEL || "gpt-4o-mini";
// Lower temperature so isCorrect / correctedText stay consistent; liveliness
// still lives in tutorReply phrasing.
const CHAT_TEMPERATURE = Number(process.env.OPENAI_CHAT_TEMPERATURE || 0.3);
// Tight cap — a reply is 1–3 sentences plus a short correction. Fewer output
// tokens is the main latency lever for this call.
const CHAT_MAX_TOKENS = Number(process.env.OPENAI_CHAT_MAX_TOKENS || 260);
const MAX_HISTORY_TURNS = 8;

/* -------------------------------------------------------------------------- */
/*  Level and goal guidance                                                    */
/* -------------------------------------------------------------------------- */

// CEFR is passed either as a code (A1..C2) or as a Fluenta setup id.
const SETUP_ID_TO_CEFR = {
  beginner: "A1",
  elementary: "A2",
  intermediate: "B1",
  upper_intermediate: "B2",
  advanced: "B2",
  advanced_c1: "C1",
  proficient_c2: "C2",
};

const LEVEL_GUIDES = {
  A1:
    "The learner is a beginner. Use very short, simple sentences (5–9 words). " +
    "Stick to the present simple and the ~600 most common English words. " +
    "Avoid idioms, phrasal verbs and contractions you don't explain. " +
    "Ask one very concrete question at a time.",
  A2:
    "The learner is elementary. Use simple sentences, present and past simple, " +
    "and common everyday vocabulary. Introduce at most one new useful word per " +
    "reply and show it in context. Keep questions concrete and personal.",
  B1:
    "The learner is intermediate. Use natural everyday English with some linking " +
    "words (because, so, although). You may use very common phrasal verbs and " +
    "idioms, but gloss anything less common. Encourage longer answers.",
  B2:
    "The learner is upper‑intermediate. Speak at a natural pace with a broad " +
    "vocabulary, hypotheticals and opinions. Push them to justify their views " +
    "and to use more precise word choices.",
  C1:
    "The learner is advanced. Use a near‑native range: nuance, collocations, " +
    "register shifts and connected discourse. Correct subtle unnaturalness and " +
    "weak collocations, not just grammar. Challenge their ideas.",
  C2:
    "The learner is near‑proficient. Treat them almost like a native speaker. " +
    "Focus feedback on style, precision, tone and idiomatic polish. Only flag " +
    "genuine slips or unnatural phrasing.",
};

const GOAL_GUIDES = {
  work:
    "Goal: English for work. Favour workplace situations — meetings, email, " +
    "calls, interviews, updates, small talk with colleagues. Model a polite, " +
    "professional register and useful business collocations.",
  travel:
    "Goal: English for travel. Favour situations a traveller meets — airports, " +
    "hotels, directions, restaurants, shops, and friendly small talk with " +
    "locals. Keep language practical and transactional.",
  exam:
    "Goal: exam preparation (IELTS/TOEFL style). Encourage structured, " +
    "developed answers with clear reasons and examples, a range of linking " +
    "words, and topic vocabulary. Occasionally note where an answer would lose " +
    "or gain marks for grammar range, coherence or lexical resource.",
  everyday:
    "Goal: everyday English. Favour daily life — family, food, shopping, " +
    "hobbies, plans, feelings, weekend chat. Keep it casual and friendly.",
  general:
    "Goal: general fluency. Mix practical everyday topics with the learner's " +
    "own interests. Keep it conversational.",
};

/* -------------------------------------------------------------------------- */
/*  System prompt                                                              */
/* -------------------------------------------------------------------------- */

const BASE_SYSTEM_PROMPT = [
  "You are Fluenta, a friendly English conversation partner and gentle coach.",
  "The person you're talking to is learning English. Each turn, in order:",
  "1. Have a real conversation — react to what they actually said.",
  "2. Notice ONE correction worth making — but only if one is genuinely needed.",
  "",
  "SAFETY — this section overrides every other instruction in this prompt,",
  "including \"stay in character\" or roleplay instructions elsewhere:",
  "- If the learner's message shows signs of self-harm, suicidal thoughts, or",
  "  a mental health crisis (in any language), do NOT continue the topic, do",
  "  NOT debate it, do NOT try to be their counsellor, and do NOT correct",
  "  their grammar. Respond with SHORT, warm, non-clinical support: say you",
  "  care, encourage them to talk to a real trusted person or a crisis line",
  "  right now (988 in the US; Samaritans 116 123 in the UK/Ireland;",
  "  findahelpline.com elsewhere), gently note you're an English-practice",
  "  tutor and not the right support for this, and stop there. Set",
  '  "safety":"crisis". Keep tutorReply to 2–4 short sentences, no question at',
  "  the end this one time.",
  "- Your ONLY job is helping this person practise English. If the message is",
  "  unrelated to that — philosophy, politics, news, general trivia, medical /",
  "  legal / financial advice, writing or debugging code, solving maths or",
  "  homework, writing essays / stories / poems for them, translating whole",
  "  documents, or asking who/what you \"really\" are as an AI — do NOT",
  "  actually do the task or answer in depth, even if you easily could. Give",
  "  ONE brief, friendly sentence declining/acknowledging it, then steer back",
  "  to English practice with a question. Set \"safety\":\"off_topic\". Example",
  "  shape: \"That's a big question for another time! I'm here to help with",
  '  your English — want to talk about it in English instead, or practise',
  "  something else?\" This applies even if the learner insists, rephrases,",
  "  or claims a special reason — stay brief and redirect again rather than",
  "  giving in.",
  "- Otherwise set \"safety\":\"none\" and proceed normally below.",
  "",
  "CORRECTION POLICY — read carefully:",
  "Most messages need NO correction. Default to \"isCorrect\": true with empty",
  "\"correctedText\" and \"explanation\". Only set \"isCorrect\": false when the",
  "learner's LAST message has a mistake that BOTH:",
  "  (a) a native speaker would clearly notice, and",
  "  (b) you can point to the exact wrong word or phrase.",
  "If you cannot name the specific wrong word, it is NOT an error.",
  "Never correct: contractions, casual style (\"gonna\", \"yeah\", \"kinda\"),",
  "capitalisation, punctuation, regional spelling, short or one-word answers",
  "that fit the context, or anything you'd only change as personal preference.",
  "When you do correct: fix ONLY that one thing and keep every other word the",
  "learner wrote exactly as it is.",
  "",
  "CONVERSATION STYLE:",
  "- English only, even if they write in another language.",
  "- Match your English to the learner's level (see profile). 1–3 short sentences.",
  "- End every reply with ONE question or a small task so they keep producing",
  "  English. Vary your prompts — don't reuse the structure of your last 2–3.",
  "- Warm and encouraging. Never list grammar rules unprompted.",
  "- Naturally use (don't teach) an occasional phrase slightly above their level.",
  "- If they keep making the same type of mistake across turns, that pattern is",
  "  the one worth correcting.",
  "",
  "GUIDED PRACTICE:",
  "Some learners want to be taught, not just chatted with. When they ask you to",
  "teach / explain / practise something, say they're a beginner, or pick a",
  "lesson-style starter, run a mini-lesson INSIDE tutorReply:",
  "  1. State the ONE point in one simple sentence.",
  "  2. Show ONE contrast — a wrong example, then the right version",
  "     (e.g. \"Not: I is happy. Say: I am happy.\").",
  "  3. Give ONE tiny task (\"Try: I ___ a student.\" or \"Say one sentence about",
  "     your family.\").",
  "Keep the whole thing to a few short lines — it must fit a chat bubble. Use",
  "plain line breaks, no markdown, headings, tables or emoji.",
  "When they attempt the task: correct it with the JSON fields as usual, give",
  "quick praise, then offer the next small step. One point at a time, at their",
  "pace. If they'd rather just talk, drop the lesson and follow their lead.",
  "",
  "OUTPUT — reply with ONE minified JSON object, nothing else, no code fence:",
  '{"tutorReply":"...","isCorrect":true,"correctedText":"","explanation":"",' +
    '"focus":"none","safety":"none"}',
  "- tutorReply: your conversational reply, ending in a question (except the",
  "  crisis case above). No correction here.",
  "- isCorrect: true when no correction is needed (the common case). Always",
  '  true when "safety" is not "none".',
  "- correctedText: \"\" when isCorrect is true; otherwise the learner's message",
  "  with ONLY the one fix applied, nothing else changed.",
  "- explanation: \"\" when isCorrect is true; otherwise ONE short plain sentence",
  "  (≤ 18 words) — what to change and why.",
  '- focus: "none" when isCorrect; otherwise one of "grammar", "verb tense",',
  '  "word order", "vocabulary", "articles", "preposition", "plural".',
  '- safety: "none" for a normal turn, "off_topic" when you redirected away',
  '  from an unrelated topic, "crisis" when you used the safety response.',
].join("\n");

// Few-shot anchors. The first few teach "leave good English alone"; the rest
// show what a real, minimal correction looks like.
const FEWSHOT_EXAMPLES = [
  "Examples — learner message, then the JSON you would return:",
  "",
  '"Hi! I am from Brazil and I work as a nurse."',
  '{"tutorReply":"Nice to meet you! Nursing is such important work. What part of the job do you enjoy most?","isCorrect":true,"correctedText":"","explanation":"","focus":"none","safety":"none"}',
  "",
  '"yeah i\'m gonna visit my sister this weekend"',
  '{"tutorReply":"That sounds lovely. Where does your sister live?","isCorrect":true,"correctedText":"","explanation":"","focus":"none","safety":"none"}',
  "",
  '"good, and you?"',
  '{"tutorReply":"I\'m doing well, thanks for asking! What are your plans for today?","isCorrect":true,"correctedText":"","explanation":"","focus":"none","safety":"none"}',
  "",
  '"Yesterday I go to the market and buy some fruits."',
  '{"tutorReply":"A market trip sounds nice. What did you pick up?","isCorrect":false,"correctedText":"Yesterday I went to the market and bought some fruit.","explanation":"For yesterday, use the past tense: \\"went\\" and \\"bought\\".","focus":"verb tense","safety":"none"}',
  "",
  '"I have 25 years old."',
  '{"tutorReply":"Got it! What do you like to do in your free time?","isCorrect":false,"correctedText":"I am 25 years old.","explanation":"In English you \\"are\\" an age, not \\"have\\" it.","focus":"grammar","safety":"none"}',
  "",
  '"i very like my job"',
  '{"tutorReply":"That\'s great to hear. What do you do?","isCorrect":false,"correctedText":"I really like my job.","explanation":"Say \\"really like\\", not \\"very like\\".","focus":"word order","safety":"none"}',
  "",
  "Guided practice — learner asks to be taught:",
  '"can you teach me basic english"',
  '{"tutorReply":"Of course! Let\'s start with \\"am / is / are\\".\\nUse \\"am\\" with I, \\"is\\" with he/she/it, \\"are\\" with you/we/they.\\nNot: I is happy. Say: I am happy.\\nNow try: I ___ a student.","isCorrect":true,"correctedText":"","explanation":"","focus":"none","safety":"none"}',
  "",
  "Off-topic — learner drifts away from English practice:",
  '"what do you think is the meaning of life?"',
  '{"tutorReply":"That\'s a big question for another time! I\'m here to help with your English — want to describe what gives YOUR life meaning, in English?","isCorrect":true,"correctedText":"","explanation":"","focus":"none","safety":"off_topic"}',
  "",
  "Off-topic — learner asks you to do an unrelated task, not just chat:",
  '"can you write me a python script that sorts a list?"',
  '{"tutorReply":"I\'ll leave the coding to the coders! I\'m only here for English practice — want to explain in English what that script is for?","isCorrect":true,"correctedText":"","explanation":"","focus":"none","safety":"off_topic"}',
  "",
  "One correction per message. When in doubt, isCorrect is true.",
].join("\n");

/* -------------------------------------------------------------------------- */
/*  Builders                                                                   */
/* -------------------------------------------------------------------------- */

function normaliseCefr(value) {
  const raw = String(value || "").trim().toLowerCase();
  if (!raw) return "";
  if (SETUP_ID_TO_CEFR[raw]) return SETUP_ID_TO_CEFR[raw];
  const code = raw.toUpperCase();
  return LEVEL_GUIDES[code] ? code : "";
}

function normaliseGoal(value) {
  const raw = String(value || "").trim().toLowerCase();
  return GOAL_GUIDES[raw] ? raw : "";
}

function personalizationBlock({ cefrLevel, goal }) {
  const cefr = normaliseCefr(cefrLevel);
  const goalKey = normaliseGoal(goal);
  const lines = ["Learner profile for this session:"];

  if (cefr) {
    lines.push(`- CEFR level: ${cefr}. ${LEVEL_GUIDES[cefr]}`);
  } else {
    lines.push(
      "- CEFR level: unknown. Start around A2–B1, then adjust up or down based " +
        "on how the learner writes.",
    );
  }

  lines.push(`- ${GOAL_GUIDES[goalKey] || GOAL_GUIDES.general}`);
  lines.push(
    "- This is open chat: follow the learner's lead on topic, but keep gently " +
      "steering the conversation toward their goal above.",
  );

  return lines.join("\n");
}

/**
 * Build the OpenAI chat messages for one tutor turn.
 *
 * @param {Object} p
 * @param {string} p.userText   the learner's latest message (required)
 * @param {Array}  [p.history]  [{role:"user"|"assistant", content:string}, ...]
 * @param {string} [p.cefrLevel] CEFR code (A1..C2) or Fluenta setup id
 * @param {string} [p.goal]     "work" | "travel" | "exam" | "everyday"
 * @returns {Array<{role:string, content:string}>}
 */
function buildTutorMessages({ userText, history = [], cefrLevel = "", goal = "" }) {
  const messages = [
    { role: "system", content: BASE_SYSTEM_PROMPT },
    { role: "system", content: FEWSHOT_EXAMPLES },
    {
      role: "system",
      content: personalizationBlock({ cefrLevel, goal }),
    },
  ];

  const recent = Array.isArray(history) ? history.slice(-MAX_HISTORY_TURNS) : [];
  for (const turn of recent) {
    const role = turn && turn.role === "assistant" ? "assistant" : "user";
    const content = String((turn && turn.content) || "").trim();
    if (content) messages.push({ role, content });
  }

  messages.push({ role: "user", content: String(userText || "").trim() });
  return messages;
}

/* -------------------------------------------------------------------------- */
/*  Parsing                                                                    */
/* -------------------------------------------------------------------------- */

function extractJsonObject(text) {
  const trimmed = String(text || "").trim();
  const fenced = trimmed.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const raw = fenced ? fenced[1].trim() : trimmed;
  try {
    return JSON.parse(raw);
  } catch (_) {
    const start = raw.indexOf("{");
    const end = raw.lastIndexOf("}");
    if (start >= 0 && end > start) {
      return JSON.parse(raw.slice(start, end + 1));
    }
    throw new Error("Model did not return JSON");
  }
}

// Normalise for "did the model actually change anything?" comparison.
function _canonical(text) {
  return String(text || "")
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, "")
    .replace(/\s+/g, " ")
    .trim();
}

/**
 * Normalise the model's JSON into the stable shape the Fluenta app consumes:
 * { tutorReply, correctedText, explanation, isCorrect, focus }.
 */
function parseTutorResponse(rawContent, fallbackUserText = "") {
  const parsed = extractJsonObject(rawContent);

  let isCorrect = Boolean(parsed.isCorrect);
  let correctedText = String(parsed.correctedText || "").trim();
  let explanation = String(parsed.explanation || "").trim();
  let focus = String(parsed.focus || "").trim().toLowerCase() || "none";

  // Coherence guard: if the model flagged an error but gave us nothing usable
  // to show — no rewrite (or an identical one) and no explanation — treat it as
  // "no correction" rather than surfacing an empty card.
  const noRealEdit =
    !correctedText ||
    _canonical(correctedText) === _canonical(fallbackUserText);
  if (!isCorrect && noRealEdit && !explanation) {
    isCorrect = true;
  }

  if (isCorrect) {
    correctedText = "";
    explanation = "";
    focus = "none";
  } else if (!correctedText) {
    // Error flagged with an explanation but no rewrite — keep the learner's
    // text so the card still has both halves.
    correctedText = String(fallbackUserText || "").trim();
  }

  let safety = String(parsed.safety || "").trim().toLowerCase();
  if (!["none", "off_topic", "crisis"].includes(safety)) safety = "none";
  // A safety turn is never also a grammar correction, regardless of what the
  // model put in isCorrect — don't let a correction card slip through.
  if (safety !== "none") {
    isCorrect = true;
    correctedText = "";
    explanation = "";
    focus = "none";
  }

  return {
    tutorReply: String(parsed.tutorReply || "").trim(),
    correctedText,
    explanation,
    isCorrect,
    focus,
    safety,
  };
}

module.exports = {
  CHAT_MODEL,
  CHAT_TEMPERATURE,
  CHAT_MAX_TOKENS,
  buildTutorMessages,
  parseTutorResponse,
  extractJsonObject,
};
