/**
 * safety.js — deterministic crisis guardrail for Fluenta's AI tutor.
 *
 * The tutor prompt (aiTutor.js) also carries safety instructions, but an LLM
 * following a prompt is not a guarantee — it can drift, especially several
 * turns into a conversation. For anything safety-critical we do NOT rely on
 * the model alone: this module pattern-matches the learner's raw message
 * *before* it ever reaches OpenAI, and when it matches, we skip the model
 * call entirely and return a fixed, pre-written response.
 *
 * This mirrors the consensus approach from public guidance on consumer AI
 * chatbots and self-harm:
 *   - APA Health Advisory on AI chatbots/wellness apps: crisis detection must
 *     trigger a tested escalation path with a pre-approved, human-written
 *     response and localized crisis-line contact info, not an ad‑hoc model
 *     reply.
 *   - OpenAI's public approach to sensitive conversations: de-escalate,
 *     don't debate or continue the topic, and point to real crisis resources
 *     (988 in the US, Samaritans in the UK, findahelpline.com elsewhere)
 *     rather than trying to "handle" the situation as a normal chat turn.
 *
 * Scope: this is a first-line net, not a clinical tool. It only recognises
 * fairly explicit English-language phrasing; ambiguous or non-English signals
 * still rely on the model-level instructions in aiTutor.js as a second layer.
 */

// Deliberately explicit, low-ambiguity phrases only — a false positive here
// (over-triggering) is a much smaller cost than a false negative would be.
const NEGATOR = "(?:don'?t|do\\s*n['o]?t|do\\s+not)";

const CRISIS_PATTERNS = [
  /\bkill(ing)?\s+my\s*self\b/i,
  /\b(end|ending)\s+my\s+(own\s+)?life\b/i,
  /\btake\s+my\s+(own\s+)?life\b/i,
  /\bwant(ed|ing)?\s+to\s+die\b/i,
  /\bwanna\s+die\b/i,
  new RegExp(`\\b${NEGATOR}\\s+want\\s+to\\s+(be\\s+alive|live)\\b`, "i"),
  /\b(be\s+alive|live)\s+anymore\b/i,
  /\bbetter\s+off\s+dead\b/i,
  /\bno\s+reason\s+to\s+live\b/i,
  /\bsuicidal\b/i,
  /\bsuicide\b/i,
  /\bself[\s-]?harm(ing)?\b/i,
  /\b(cut|cutting|hurt|hurting)\s+my\s*self\b/i,
  /\bend(ing)?\s+it\s+all\b/i,
  /\bdisappear\s+forever\b/i,
];

/** True when [text] contains an explicit self-harm / suicide crisis signal. */
function detectCrisisSignal(text) {
  const raw = String(text || "");
  if (!raw.trim()) return false;
  return CRISIS_PATTERNS.some((pattern) => pattern.test(raw));
}

// Short, warm, non-clinical, and identical every time — a crisis response
// should never be improvised. Kept level-neutral (simple English) since we
// don't know the learner's CEFR level at this point and clarity matters most
// here. Resources follow the OpenAI / APA pattern: a US line, a UK line, and
// an international directory, because Fluenta has no reliable location data.
const CRISIS_REPLY = [
  "I'm really sorry you're feeling this way. You matter, and this isn't",
  "something to go through alone — please reach out to a real person who can",
  "help right now: a trusted friend or family member, or a crisis line.",
  "In the US, call or text 988. In the UK or Ireland, call Samaritans at 116",
  "123. Anywhere else, you can find a local helpline at findahelpline.com.",
  "If you are in immediate danger, please contact your local emergency",
  "number.",
  "",
  "I'm an English‑practice tutor, so I'm not the right support for this —",
  "but I'll be here for English practice whenever you're ready.",
].join(" ").replace(/ \n /g, "\n").replace(/\s+\n/g, "\n");

/**
 * The fixed object to return in place of a model call when
 * [detectCrisisSignal] matches. Shape matches aiTutor.parseTutorResponse's
 * output so callers can treat it identically to a normal turn.
 */
function crisisResponse() {
  return {
    tutorReply: CRISIS_REPLY,
    correctedText: "",
    explanation: "",
    isCorrect: true,
    focus: "none",
    safety: "crisis",
  };
}

module.exports = {
  detectCrisisSignal,
  crisisResponse,
};
