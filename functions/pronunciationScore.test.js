"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");
const { scorePronunciation, wordProbabilities } = require("./pronunciationScore");

const PHRASE = "Please check the report.";

function tokens(words, logprob = -0.02) {
  return words.map((w, i) => ({ token: (i ? " " : "") + w, logprob }));
}

test("perfect, confident speech scores in the high 90s", () => {
  const r = scorePronunciation({
    phrase: PHRASE,
    transcript: "Please check the report.",
    logprobs: tokens(["Please", "check", "the", "report"]).concat([{ token: ".", logprob: -0.01 }]),
  });
  assert.equal(r.heardAnything, true);
  assert.ok(r.overallScore >= 95, `score ${r.overallScore}`);
  assert.equal(r.words.length, 4);
  assert.ok(r.words.every((w) => w.weakSounds.length === 0));
});

test("a substituted word is well below 85 and reports what was heard", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "Please chick the report" });
  const check = r.words.find((w) => w.word === "check");
  assert.equal(check.spokenWord, "chick");
  assert.ok(check.confidence < 85, `check ${check.confidence}`);
  assert.ok(check.weakCharIndices.length > 0);
  assert.ok(r.overallScore < 80, `overall ${r.overallScore}`);
});

test("a skipped word scores 0 and is reported as not spoken", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "Please check report" });
  const the = r.words.find((w) => w.word === "the");
  assert.equal(the.confidence, 0);
  assert.equal(the.spokenWord, null);
  assert.ok(r.overallScore < 85);
});

test("extra words cost points but never below the word scores' penalty cap", () => {
  const clean = scorePronunciation({ phrase: PHRASE, transcript: "Please check the report" });
  const extra = scorePronunciation({
    phrase: PHRASE,
    transcript: "well please check the report now really",
  });
  assert.ok(extra.overallScore < clean.overallScore);
  assert.ok(clean.overallScore - extra.overallScore <= 20);
});

test("low recogniser confidence drops an otherwise exact word below 85", () => {
  const lp = tokens(["Please", "check", "the", "report"]);
  lp[1].logprob = -1.2; // "check" was barely recognised
  const r = scorePronunciation({ phrase: PHRASE, transcript: "Please check the report", logprobs: lp });
  const check = r.words.find((w) => w.word === "check");
  assert.ok(check.confidence < 85, `check ${check.confidence}`);
  assert.ok(check.weakSounds.includes("/ch/"));
});

test("empty transcript means nothing was heard", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "  " });
  assert.equal(r.heardAnything, false);
  assert.equal(r.overallScore, 0);
  assert.deepEqual(r.words, []);
});

test("a typical silence hallucination is treated as nothing heard", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "Thank you." });
  assert.equal(r.heardAnything, false);
  assert.equal(r.overallScore, 0);
});

test("saying the phrase that contains 'thank you' is not mistaken for silence", () => {
  const r = scorePronunciation({
    phrase: "Thank you for your help.",
    transcript: "Thank you for your help",
  });
  assert.equal(r.heardAnything, true);
  assert.ok(r.overallScore >= 90);
});

test("contractions and curly apostrophes match", () => {
  const r = scorePronunciation({ phrase: "I don’t know.", transcript: "I don't know" });
  assert.ok(r.overallScore >= 90, `score ${r.overallScore}`);
});

test("word probabilities are ignored when tokens do not line up with the transcript", () => {
  assert.equal(wordProbabilities(tokens(["Hello", "there"]), "hello there again"), null);
  assert.equal(wordProbabilities(null, "hello"), null);
});

test("multi-token words are grouped into one word", () => {
  const lp = [
    { token: "Don", logprob: -0.1 },
    { token: "'t", logprob: -0.1 },
    { token: " go", logprob: -0.2 },
  ];
  const p = wordProbabilities(lp, "Don't go");
  assert.equal(p.length, 2);
  assert.ok(p[0] > 0.85 && p[1] > 0.75);
});

test("saying a completely different sentence still reports what was heard", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "Hello how are you today" });
  assert.equal(r.heardAnything, true);
  assert.ok(r.overallScore < 35, `score ${r.overallScore}`);
  assert.equal(r.words.length, 4);
  assert.ok(r.words.every((w) => w.confidence < 50));
  assert.ok(r.words.some((w) => w.spokenWord));
});

test("non-Latin words from the recogniser still count as speech", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "پلیز چیک" });
  assert.equal(r.heardAnything, true);
  assert.ok(r.overallScore < 20);
});

test("a single real word such as okay is not treated as silence", () => {
  const r = scorePronunciation({ phrase: PHRASE, transcript: "Okay" });
  assert.equal(r.heardAnything, true);
});
