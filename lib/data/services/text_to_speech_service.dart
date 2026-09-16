import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  TextToSpeechService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _initialized = false;
  int _speakGeneration = 0;
  String? _activeLanguageCode;

  Future<void> initialize() async {
    if (_initialized) return;

    await _tts.awaitSpeakCompletion(true);
    await _configureFor('en');
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _initialized = true;
  }

  /// Reads [text] aloud.
  ///
  /// [languageCode] is the learner's app language (`en`, `es`, `fr`, `ur`).
  /// English is spoken slowly for practice; other languages use a normal
  /// rate and matching voice. Mixed replies (quoted English, Urdu script)
  /// are split so each part uses the right voice and speed.
  Future<bool> speak(
    String text, {
    String? languageCode,
    VoidCallback? onComplete,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    final generation = ++_speakGeneration;

    try {
      await initialize();
      await _tts.stop();

      final segments = segmentForSpeech(
        trimmed,
        nativeLanguage: languageCode,
      );
      if (segments.isEmpty) return false;

      for (final segment in segments) {
        if (generation != _speakGeneration) return false;
        await _configureFor(segment.languageCode);
        final result = await _tts.speak(segment.text);
        if (result != 1) return false;
      }

      if (generation == _speakGeneration) {
        onComplete?.call();
      }
      return generation == _speakGeneration;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('TextToSpeechService.speak failed: $e');
      }
      return false;
    }
  }

  Future<void> stop() async {
    _speakGeneration++;
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<void> _configureFor(String languageCode) async {
    if (_activeLanguageCode == languageCode) return;

    final locales = _localeCandidates(languageCode);
    var applied = false;
    for (final locale in locales) {
      try {
        final available = await _tts.isLanguageAvailable(locale);
        if (available == true || available == 1) {
          await _tts.setLanguage(locale);
          applied = true;
          break;
        }
      } catch (_) {}
    }
    if (!applied) {
      await _tts.setLanguage(locales.first);
    }

    await _tts.setSpeechRate(_speechRate(languageCode));
    _activeLanguageCode = languageCode;
  }

  double _speechRate(String languageCode) {
    final isEnglish = languageCode == 'en';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return isEnglish ? 0.45 : 0.53;
      default:
        return isEnglish ? 0.45 : 0.62;
    }
  }

  List<String> _localeCandidates(String languageCode) {
    switch (languageCode) {
      case 'es':
        return const ['es-ES', 'es-MX', 'es'];
      case 'fr':
        return const ['fr-FR', 'fr'];
      case 'ur':
        return const ['ur-PK', 'ur-IN', 'ur'];
      default:
        return const ['en-US', 'en'];
    }
  }
}

class TtsSegment {
  const TtsSegment({required this.text, required this.languageCode});

  final String text;
  final String languageCode;
}

/// Splits mixed tutor text into language runs for TTS.
@visibleForTesting
List<TtsSegment> segmentForSpeech(
  String text, {
  String? nativeLanguage,
}) {
  final native = _normalizeLang(nativeLanguage);
  final latinLang = native == 'ur' ? 'en' : native;
  final scriptRuns = _splitByScript(text, nativeLatin: latinLang);
  final expanded = <TtsSegment>[];
  for (final run in scriptRuns) {
    if (run.languageCode == 'ur' || native == 'en') {
      expanded.add(run);
      continue;
    }
    for (final quoted in _splitQuotedEnglish(run.text, native)) {
      if (quoted.languageCode == 'en') {
        expanded.add(quoted);
      } else {
        expanded.add(
          TtsSegment(
            text: quoted.text,
            languageCode: _classifyLatin(quoted.text, native),
          ),
        );
      }
    }
  }
  return _mergeAdjacent(expanded);
}

String _normalizeLang(String? code) {
  switch ((code ?? 'en').trim().toLowerCase()) {
    case 'es':
    case 'fr':
    case 'ur':
      return code!.trim().toLowerCase();
    default:
      return 'en';
  }
}

enum _ScriptKind { latin, arabic, other }

_ScriptKind _scriptKind(int rune) {
  if ((rune >= 0x0600 && rune <= 0x06FF) ||
      (rune >= 0x0750 && rune <= 0x077F) ||
      (rune >= 0x08A0 && rune <= 0x08FF) ||
      (rune >= 0xFB50 && rune <= 0xFDFF) ||
      (rune >= 0xFE70 && rune <= 0xFEFF)) {
    return _ScriptKind.arabic;
  }
  if ((rune >= 0x41 && rune <= 0x5A) ||
      (rune >= 0x61 && rune <= 0x7A) ||
      (rune >= 0xC0 && rune <= 0x024F) ||
      (rune >= 0x1E00 && rune <= 0x1EFF)) {
    return _ScriptKind.latin;
  }
  return _ScriptKind.other;
}

List<TtsSegment> _splitByScript(String text, {required String nativeLatin}) {
  if (text.isEmpty) return const [];

  final runs = <TtsSegment>[];
  final buffer = StringBuffer();
  _ScriptKind? active;

  void flush() {
    final chunk = buffer.toString();
    buffer.clear();
    if (chunk.trim().isEmpty) {
      if (runs.isNotEmpty) {
        runs[runs.length - 1] = TtsSegment(
          text: runs.last.text + chunk,
          languageCode: runs.last.languageCode,
        );
      }
      return;
    }
    final lang = active == _ScriptKind.arabic ? 'ur' : nativeLatin;
    runs.add(TtsSegment(text: chunk, languageCode: lang));
  }

  for (final rune in text.runes) {
    final kind = _scriptKind(rune);
    if (kind == _ScriptKind.other) {
      buffer.writeCharCode(rune);
      continue;
    }
    if (active != null && kind != active) {
      flush();
    }
    active = kind;
    buffer.writeCharCode(rune);
  }
  flush();
  return runs;
}

List<TtsSegment> _splitQuotedEnglish(String text, String nativeLang) {
  final segments = <TtsSegment>[];
  final buffer = StringBuffer();
  String? closer;

  void flush(String languageCode) {
    final chunk = buffer.toString();
    buffer.clear();
    if (chunk.trim().isEmpty) {
      if (chunk.isNotEmpty && segments.isNotEmpty) {
        segments[segments.length - 1] = TtsSegment(
          text: segments.last.text + chunk,
          languageCode: segments.last.languageCode,
        );
      }
      return;
    }
    segments.add(TtsSegment(text: chunk, languageCode: languageCode));
  }

  for (final rune in text.runes) {
    final char = String.fromCharCode(rune);
    if (closer == null) {
      final match = _quoteCloser(char);
      if (match != null) {
        flush(nativeLang);
        closer = match;
        continue;
      }
      buffer.writeCharCode(rune);
      continue;
    }

    if (char == closer) {
      flush('en');
      closer = null;
      continue;
    }
    buffer.writeCharCode(rune);
  }

  flush(closer == null ? nativeLang : 'en');
  return segments;
}

String? _quoteCloser(String char) {
  switch (char) {
    case '"':
      return '"';
    case '“':
      return '”';
    case '«':
      return '»';
    default:
      return null;
  }
}

String _classifyLatin(String text, String nativeLang) {
  final lower = text.toLowerCase();
  final nativeHits = _countHits(lower, _nativeMarkers(nativeLang));
  final englishHits = _countHits(lower, _englishMarkers);
  if (nativeHits == 0 && englishHits == 0) {
    return _hasNativeLetters(text, nativeLang) ? nativeLang : 'en';
  }
  return nativeHits >= englishHits ? nativeLang : 'en';
}

int _countHits(String lower, List<String> markers) {
  var count = 0;
  for (final marker in markers) {
    if (RegExp('\\b${RegExp.escape(marker)}\\b').hasMatch(lower)) {
      count++;
    }
  }
  return count;
}

bool _hasNativeLetters(String text, String nativeLang) {
  switch (nativeLang) {
    case 'es':
      return RegExp(r'[áéíóúñü¿¡]', caseSensitive: false).hasMatch(text);
    case 'fr':
      return RegExp(r'[àâçéèêëîïôùûüÿœæ]', caseSensitive: false).hasMatch(text);
    default:
      return false;
  }
}

const _englishMarkers = [
  'the',
  'is',
  'are',
  'you',
  'your',
  'and',
  'this',
  'that',
  'have',
  'what',
  'how',
  'please',
  "let's",
];

List<String> _nativeMarkers(String nativeLang) {
  switch (nativeLang) {
    case 'es':
      return const [
        'el',
        'la',
        'los',
        'las',
        'que',
        'una',
        'por',
        'para',
        'como',
        'pero',
        'hola',
        'significa',
        'puedes',
        'vamos',
      ];
    case 'fr':
      return const [
        'les',
        'une',
        'est',
        'que',
        'vous',
        'pas',
        'pour',
        'avec',
        'dans',
        'mais',
        'comment',
        'signifie',
        'bonjour',
      ];
    default:
      return const [];
  }
}

List<TtsSegment> _mergeAdjacent(List<TtsSegment> segments) {
  if (segments.isEmpty) return segments;
  final merged = <TtsSegment>[segments.first];
  for (var i = 1; i < segments.length; i++) {
    final current = segments[i];
    final last = merged.last;
    if (current.languageCode == last.languageCode) {
      merged[merged.length - 1] = TtsSegment(
        text: last.text + current.text,
        languageCode: last.languageCode,
      );
    } else {
      merged.add(current);
    }
  }
  return merged
      .where((segment) => segment.text.trim().isNotEmpty)
      .map(
        (segment) => TtsSegment(
          text: segment.text.trim(),
          languageCode: segment.languageCode,
        ),
      )
      .toList();
}
