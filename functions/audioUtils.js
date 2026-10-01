"use strict";

/**
 * Quiet recordings are the most common reason a speech model returns nothing.
 * For 16-bit PCM WAV (what the app records) this scales the samples so the
 * loudest one sits near full scale. Anything else is returned untouched.
 */

const TARGET_PEAK = 0.85 * 32767;
const MIN_PEAK_TO_BOOST = 300; // below this it is silence / noise floor
const MIN_GAIN_WORTH_APPLYING = 1.3;
const MAX_GAIN = 10;

function findPcmData(buffer) {
  if (
    buffer.length < 44 ||
    buffer.toString("ascii", 0, 4) !== "RIFF" ||
    buffer.toString("ascii", 8, 12) !== "WAVE"
  ) {
    return null;
  }
  let offset = 12;
  let fmt = null;
  while (offset + 8 <= buffer.length) {
    const id = buffer.toString("ascii", offset, offset + 4);
    const size = buffer.readUInt32LE(offset + 4);
    if (id === "fmt " && offset + 24 <= buffer.length) {
      fmt = {
        format: buffer.readUInt16LE(offset + 8),
        bits: buffer.readUInt16LE(offset + 22),
      };
    } else if (id === "data") {
      const start = offset + 8;
      const available = buffer.length - start;
      // Some writers leave the size as 0 or 0xFFFFFFFF; trust what is there.
      const length = size === 0 || size > available ? available : size;
      if (!fmt || fmt.format !== 1 || fmt.bits !== 16) return null;
      return { start, length: length - (length % 2) };
    }
    offset += 8 + size + (size % 2);
  }
  return null;
}

function peakOf(buffer, start, length) {
  let peak = 0;
  for (let i = start; i < start + length; i += 2) {
    const value = Math.abs(buffer.readInt16LE(i));
    if (value > peak) peak = value;
  }
  return peak;
}

/** @returns {{buffer: Buffer, peak: number|null, gain: number}} */
function normaliseWavLevel(input) {
  const data = findPcmData(input);
  if (!data || data.length < 2) return { buffer: input, peak: null, gain: 1 };

  const peak = peakOf(input, data.start, data.length);
  if (peak < MIN_PEAK_TO_BOOST) return { buffer: input, peak, gain: 1 };

  const gain = Math.min(MAX_GAIN, TARGET_PEAK / peak);
  if (gain < MIN_GAIN_WORTH_APPLYING) return { buffer: input, peak, gain: 1 };

  const output = Buffer.from(input);
  for (let i = data.start; i < data.start + data.length; i += 2) {
    const scaled = Math.round(input.readInt16LE(i) * gain);
    output.writeInt16LE(Math.max(-32768, Math.min(32767, scaled)), i);
  }
  return { buffer: output, peak, gain };
}

module.exports = { normaliseWavLevel };
