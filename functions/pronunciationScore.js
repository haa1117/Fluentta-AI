"use strict";

/**
 * Deterministic pronunciation scoring.
 *
 * The audio is transcribed "blind" (the model never sees the target phrase),
 * then the transcript is aligned to the phrase with plain code. Scores come
 * from that alignment and from the recogniser's own token confidence, never
 * from a language model's opinion. This is a transcript-level check, not a
 * phoneme-level one.
 */

const TRICKY_SOUNDS = [
  "tion", "sion", "ough", "th", "sh", "ch", "ph", "wh", "ng", "gh", "ed", "ly",
];

// Speech models sometimes invent these on silence or noise.
const SILENCE_HALLUCINATIONS = new Set([
  "thank you",
  "thanks for watching",
  "thank you for watching",
  "you",
  "bye",
]);

const INSERTION_PENALTY = 4;
const MAX_INSERTION_PENALTY = 20;
const NEAR_MATCH_MIN_SIMILARITY = 0.4;

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}

function normaliseWord(word) {
  return String(word || "")
    .toLowerCase()
    .replace(/[‘’]/g, "'")
    .replace(/[^a-z0-9']/g, "");
}

/** Words of the target phrase with punctuation stripped, original casing. */
function expectedWordsOf(phrase) {
  return String(phrase || "").replace(/[‘’]/g, "'").match(/[A-Za-z0-9']+/g) || [];
}

/** Lower-case words of a transcript. */
function spokenWordsOf(transcript) {
  return (
    String(transcript || "")
      .toLowerCase()
      .replace(/[‘’]/g, "'")
      .match(/[\p{L}\p{N}']+/gu) || []
  );
}

function levenshtein(a, b) {
  if (a === b) return 0;
  if (!a.length) return b.length;
  if (!b.length) return a.length;
  let previous = Array.from({ length: b.length + 1 }, (_, i) => i);
  for (let i = 0; i < a.length; i++) {
    const current = [i + 1];
    for (let j = 0; j < b.length; j++) {
      const cost = a[i] === b[j] ? 0 : 1;
      current[j + 1] = Math.min(current[j] + 1, previous[j + 1] + 1, previous[j] + cost);
    }
    previous = current;
  }
  return previous[b.length];
}

function similarity(a, b) {
  if (!a.length && !b.length) return 1;
  if (!a.length || !b.length) return 0;
  return 1 - levenshtein(a, b) / Math.max(a.length, b.length);
}

/**
 * Groups recogniser tokens (with logprobs) into words and returns one
 * probability per word, or null when the grouping doesn't line up with the
 * transcript (in which case confidence is simply not used).
 */
function wordProbabilities(logprobs, transcript) {
  if (!Array.isArray(logprobs) || !logprobs.length) return null;
  const groups = [];
  let current = null;
  for (const item of logprobs) {
    const token = String(item && item.token != null ? item.token : "");
    const logprob = Number(item && item.logprob);
    if (!/[\p{L}\p{N}]/u.test(token)) continue; // punctuation / whitespace only
    const startsNew = current === null || /^\s/.test(token);
    if (startsNew) {
      current = { sum: 0, count: 0 };
      groups.push(current);
    }
    if (Number.isFinite(logprob)) {
      current.sum += logprob;
      current.count += 1;
    }
  }
  const words = spokenWordsOf(transcript);
  if (groups.length !== words.length) return null;
  return groups.map((g) => (g.count ? clamp(Math.exp(g.sum / g.count), 0, 1) : null));
}

/**
 * Word-level alignment of expected words to spoken words.
 * Returns { pairs: [spokenIndex | null per expected word], insertions }.
 */
function alignWords(expected, spoken) {
  const n = expected.length;
  const m = spoken.length;
  const cost = Array.from({ length: n + 1 }, () => new Array(m + 1).fill(0));
  for (let i = 1; i <= n; i++) cost[i][0] = i;
  for (let j = 1; j <= m; j++) cost[0][j] = j;

  const subCost = (i, j) => {
    const s = similarity(normaliseWord(expected[i]), normaliseWord(spoken[j]));
    return s >= NEAR_MATCH_MIN_SIMILARITY ? 1 - s : 1;
  };

  for (let i = 1; i <= n; i++) {
    for (let j = 1; j <= m; j++) {
      cost[i][j] = Math.min(
        cost[i - 1][j] + 1,
        cost[i][j - 1] + 1,
        cost[i - 1][j - 1] + subCost(i - 1, j - 1),
      );
    }
  }

  const pairs = new Array(n).fill(null);
  let insertions = 0;
  let i = n;
  let j = m;
  while (i > 0 || j > 0) {
    if (i > 0 && j > 0 && Math.abs(cost[i][j] - (cost[i - 1][j - 1] + subCost(i - 1, j - 1))) < 1e-9) {
      pairs[i - 1] = j - 1;
      i--;
      j--;
    } else if (i > 0 && Math.abs(cost[i][j] - (cost[i - 1][j] + 1)) < 1e-9) {
      i--; // expected word never spoken
    } else {
      insertions++; // extra spoken word
      j--;
    }
  }
  return { pairs, insertions };
}

function mismatchIndices(expected, spoken) {
  const n = expected.length;
  const m = spoken.length;
  const dp = Array.from({ length: n + 1 }, () => new Array(m + 1).fill(0));
  for (let i = 0; i <= n; i++) dp[i][0] = i;
  for (let j = 0; j <= m; j++) dp[0][j] = j;
  for (let i = 1; i <= n; i++) {
    for (let j = 1; j <= m; j++) {
      const c = expected[i - 1] === spoken[j - 1] ? 0 : 1;
      dp[i][j] = Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + c);
    }
  }
  const out = new Set();
  let i = n;
  let j = m;
  while (i > 0 || j > 0) {
    if (i > 0 && j > 0 && dp[i][j] === dp[i - 1][j - 1] && expected[i - 1] === spoken[j - 1]) {
      i--;
      j--;
    } else if (i > 0 && dp[i][j] === dp[i - 1][j] + 1) {
      out.add(i - 1);
      i--;
    } else if (j > 0 && dp[i][j] === dp[i][j - 1] + 1) {
      j--;
    } else if (i > 0 && j > 0) {
      out.add(i - 1);
      i--;
      j--;
    } else {
      break;
    }
  }
  return [...out].sort((a, b) => a - b);
}

function markPattern(word, pattern, indices) {
  const lower = word.toLowerCase();
  let start = 0;
  for (;;) {
    const found = lower.indexOf(pattern, start);
    if (found < 0) break;
    for (let k = found; k < found + pattern.length; k++) indices.add(k);
    start = found + 1;
  }
}

/** Weak sounds for a word: tricky patterns that were lost, plus differing letters. */
function weakSoundsFor(expectedWord, spokenWord, { includeAllPatterns = false } = {}) {
  const expected = normaliseWord(expectedWord);
  const spoken = spokenWord ? normaliseWord(spokenWord) : "";
  const sounds = new Set();
  const indices = new Set();

  for (const pattern of TRICKY_SOUNDS) {
    if (!expected.includes(pattern)) continue;
    if (includeAllPatterns || !spoken.includes(pattern)) {
      sounds.add(`/${pattern}/`);
      markPattern(expectedWord, pattern, indices);
    }
  }

  if (spoken) {
    for (const index of mismatchIndices(expected, spoken)) {
      if (index < expectedWord.length) {
        indices.add(index);
        const ch = expectedWord[index].toLowerCase();
        if (/[a-z]/.test(ch)) sounds.add(`'${ch}'`);
      }
    }
  } else if (!sounds.size) {
    for (let k = 0; k < expectedWord.length; k++) indices.add(k);
  }

  return {
    weakSounds: [...sounds].slice(0, 4),
    weakCharIndices: [...indices].filter((i) => i < expectedWord.length).sort((a, b) => a - b),
  };
}

function scoreWord(expectedWord, spokenWord, probability) {
  if (spokenWord == null) return 0;
  const expected = normaliseWord(expectedWord);
  const p = probability == null ? 0.9 : probability;
  if (expected === spokenWord) {
    // A clear, confidently recognised word lands in the 90s; a hesitant one
    // drops below the 85 "needs practice" line.
    return Math.round(55 + 45 * p);
  }
  const s = similarity(expected, normaliseWord(spokenWord));
  const base = Math.min(s, 0.95) * 70;
  return Math.round(base * (0.85 + 0.15 * p));
}

function looksLikeSilenceHallucination(spoken, matchedCount) {
  if (matchedCount > 0) return false;
  return SILENCE_HALLUCINATIONS.has(spoken.join(" "));
}

/**
 * @param {string} phrase       the phrase the learner was asked to say
 * @param {string} transcript   blind transcript of what they actually said
 * @param {Array|null} logprobs recogniser token logprobs, if available
 */
function scorePronunciation({ phrase, transcript, logprobs }) {
  const expected = expectedWordsOf(phrase);
  const spoken = spokenWordsOf(transcript);
  const probabilities = wordProbabilities(logprobs, transcript);

  const { pairs, insertions } = alignWords(expected, spoken);
  const exactCount = pairs.filter(
    (spokenIndex, i) => spokenIndex != null && normaliseWord(expected[i]) === spoken[spokenIndex],
  ).length;

  const heardAnything = spoken.length > 0 && !looksLikeSilenceHallucination(spoken, exactCount);
  if (!heardAnything || !expected.length) {
    return {
      transcript: String(transcript || "").trim(),
      heardAnything: false,
      overallScore: 0,
      words: [],
    };
  }

  const words = expected.map((word, i) => {
    const spokenIndex = pairs[i];
    const spokenWord = spokenIndex == null ? null : spoken[spokenIndex];
    const probability =
      spokenIndex == null || !probabilities ? null : probabilities[spokenIndex];
    const confidence = clamp(scoreWord(word, spokenWord, probability), 0, 100);
    const exact = spokenWord != null && normaliseWord(word) === spokenWord;
    const hesitant = exact && confidence < 85;
    const weak =
      exact && !hesitant
        ? { weakSounds: [], weakCharIndices: [] }
        : weakSoundsFor(word, spokenWord, { includeAllPatterns: hesitant });
    return {
      word,
      confidence,
      spokenWord,
      weakSounds: weak.weakSounds,
      weakCharIndices: weak.weakCharIndices,
    };
  });

  const average = words.reduce((sum, w) => sum + w.confidence, 0) / words.length;
  const weakest = Math.min(...words.map((w) => w.confidence));
  // One badly missed word must visibly pull the total down, not vanish into
  // the average of the words that were fine.
  const blended = average * 0.7 + weakest * 0.3;
  const penalty = Math.min(MAX_INSERTION_PENALTY, insertions * INSERTION_PENALTY);

  return {
    transcript: String(transcript || "").trim(),
    heardAnything: true,
    overallScore: clamp(Math.round(blended - penalty), 0, 100),
    words,
  };
}

module.exports = {
  scorePronunciation,
  wordProbabilities,
  alignWords,
  expectedWordsOf,
  spokenWordsOf,
  normaliseWord,
  similarity,
};
