"use strict";

const test = require("node:test");
const assert = require("node:assert/strict");
const { normaliseWavLevel } = require("./audioUtils");

function wav(samples) {
  const data = Buffer.alloc(samples.length * 2);
  samples.forEach((s, i) => data.writeInt16LE(s, i * 2));
  const header = Buffer.alloc(44);
  header.write("RIFF", 0, "ascii");
  header.writeUInt32LE(36 + data.length, 4);
  header.write("WAVE", 8, "ascii");
  header.write("fmt ", 12, "ascii");
  header.writeUInt32LE(16, 16);
  header.writeUInt16LE(1, 20); // PCM
  header.writeUInt16LE(1, 22); // mono
  header.writeUInt32LE(16000, 24);
  header.writeUInt32LE(32000, 28);
  header.writeUInt16LE(2, 32);
  header.writeUInt16LE(16, 34);
  header.write("data", 36, "ascii");
  header.writeUInt32LE(data.length, 40);
  return Buffer.concat([header, data]);
}

test("a quiet recording is boosted towards full scale", () => {
  const quiet = wav([0, 1000, -1200, 800, -900]);
  const out = normaliseWavLevel(quiet);
  assert.equal(out.gain, 10, "gain is capped so noise is not blown up");
  const peak = Math.max(...[0, 1, 2, 3, 4].map((i) => Math.abs(out.buffer.readInt16LE(44 + i * 2))));
  assert.ok(peak >= 11000 && peak <= 13000, `peak ${peak}`);
  assert.equal(quiet.readInt16LE(46), 1000, "input buffer is not modified");
});

test("a loud recording is left alone", () => {
  const loud = wav([0, 30000, -29000]);
  const out = normaliseWavLevel(loud);
  assert.equal(out.gain, 1);
  assert.equal(out.buffer, loud);
});

test("near-silence is not amplified", () => {
  const silent = wav([0, 5, -8, 3]);
  const out = normaliseWavLevel(silent);
  assert.equal(out.gain, 1);
});

test("non-WAV data is returned untouched", () => {
  const junk = Buffer.from("not a wav file at all, just some bytes here....");
  const out = normaliseWavLevel(junk);
  assert.equal(out.buffer, junk);
  assert.equal(out.peak, null);
});

test("a WAV whose data size is 0 (streamed header) is still processed", () => {
  const quiet = wav([0, 1000, -1200, 800]);
  quiet.writeUInt32LE(0, 40);
  const out = normaliseWavLevel(quiet);
  assert.ok(out.gain > 5);
});
