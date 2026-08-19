import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/data/models/pronunciation_phrase_model.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum PronunciationStartFailure {
  none,
  permissionDenied,
  unavailable,
}

class PronunciationAssessmentService {
  PronunciationAssessmentService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _initialized = false;
  bool _sessionActive = false;
  bool _isListening = false;
  bool _isRestarting = false;
  String _transcript = '';
  void Function(double level)? _onSoundLevel;
  PronunciationStartFailure _lastStartFailure = PronunciationStartFailure.none;

  bool get isListening => _isListening;
  String get transcript => _transcript;
  PronunciationStartFailure get lastStartFailure => _lastStartFailure;

  static const _retryableErrors = {
    'error_speech_timeout',
    'error_no_match',
  };

  Future<bool> initialize() async {
    if (_initialized) {
      return _speech.isAvailable;
    }

    try {
      _initialized = await _speech.initialize(
        onError: _handleRecognitionError,
        onStatus: _handleRecognitionStatus,
        debugLogging: kDebugMode,
        finalTimeout: const Duration(milliseconds: 1500),
      );
      return _initialized && _speech.isAvailable;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechToText initialize failed: $e');
      }
      return false;
    }
  }

  void _handleRecognitionError(SpeechRecognitionError error) {
    if (kDebugMode) {
      debugPrint('SpeechToText error: ${error.errorMsg}');
    }

    if (!_sessionActive) return;

    if (_retryableErrors.contains(error.errorMsg)) {
      _scheduleListenRestart();
      return;
    }

    _isListening = false;
  }

  void _handleRecognitionStatus(String status) {
    if (kDebugMode) {
      debugPrint('SpeechToText status: $status');
    }

    if (status == 'listening') {
      _isListening = true;
      return;
    }

    if (status == 'notListening' || status == 'done') {
      _isListening = false;
      if (_sessionActive) {
        _scheduleListenRestart();
      }
    }
  }

  void _scheduleListenRestart() {
    if (!_sessionActive || _isRestarting || _speech.isListening) return;

    _isRestarting = true;
    Future<void>.delayed(const Duration(milliseconds: 350), () async {
      _isRestarting = false;
      if (!_sessionActive || _speech.isListening) return;
      await _beginListenAttempt();
    });
  }

  Future<bool> _ensureMicrophonePermission() async {
    final ready = await initialize();
    if (!ready) return false;
    return _speech.hasPermission;
  }

  Future<bool> startListening({
    void Function(double level)? onSoundLevel,
  }) async {
    _lastStartFailure = PronunciationStartFailure.none;
    _sessionActive = true;
    _onSoundLevel = onSoundLevel;
    _transcript = '';

    if (!await _ensureMicrophonePermission()) {
      _sessionActive = false;
      _lastStartFailure = PronunciationStartFailure.permissionDenied;
      return false;
    }

    final ready = await initialize();
    if (!ready || !_speech.isAvailable) {
      _sessionActive = false;
      _lastStartFailure = PronunciationStartFailure.unavailable;
      return false;
    }

    if (_speech.isListening) {
      await _speech.stop();
    }

    // Give the user a moment to raise the phone and start speaking.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final started = await _beginListenAttempt();
    if (!started && _sessionActive) {
      _lastStartFailure = PronunciationStartFailure.unavailable;
    }
    return started || _sessionActive;
  }

  Future<bool> _beginListenAttempt() async {
    if (!_sessionActive) return false;

    try {
      await _speech.listen(
        onResult: (result) {
          final words = result.recognizedWords.trim();
          if (words.isEmpty) return;

          _transcript = words;

          if (_speech.isListening) {
            _speech.changePauseFor(const Duration(seconds: 12));
          }
        },
        listenOptions: SpeechListenOptions(
          listenFor: const Duration(minutes: 1),
          pauseFor: const Duration(seconds: 30),
          localeId: await _preferredLocaleId(),
          partialResults: true,
          cancelOnError: false,
          listenMode: ListenMode.confirmation,
        ),
        onSoundLevelChange: _onSoundLevel,
      );

      await Future<void>.delayed(const Duration(milliseconds: 250));
      _isListening = _speech.isListening || _sessionActive;
      return _isListening;
    } on ListenFailedException catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechToText listen failed: ${e.message}');
      }
      _isListening = false;
      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SpeechToText listen failed: $e');
      }
      _isListening = false;
      return false;
    }
  }

  Future<String?> _preferredLocaleId() async {
    try {
      final locales = await _speech.locales();
      if (locales.isEmpty) return 'en_US';

      for (final preferred in ['en_US', 'en_GB', 'en']) {
        final match = locales
            .where((locale) => locale.localeId.startsWith(preferred))
            .firstOrNull;
        if (match != null) return match.localeId;
      }
      return locales.first.localeId;
    } catch (_) {
      return 'en_US';
    }
  }

  Future<String> stopListening() async {
    _sessionActive = false;
    _isRestarting = false;

    if (_speech.isListening) {
      await _speech.stop();
    }
    _isListening = false;

    // Allow final recognition result to arrive after stop.
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _transcript.trim();
  }

  void cancelListening() {
    _sessionActive = false;
    _isRestarting = false;
    _speech.cancel();
    _isListening = false;
    _transcript = '';
  }

  PronunciationAssessmentResult assess({
    required String expectedPhrase,
    required String spokenText,
  }) {
    final expectedWords = _extractWords(expectedPhrase);
    final spokenWords = _tokenize(spokenText);
    final words = <PronunciationWordFeedback>[];

    for (var index = 0; index < expectedWords.length; index++) {
      final displayWord = expectedWords[index];
      final expectedToken =
          _tokenize(displayWord).firstOrNull ?? displayWord.toLowerCase();
      final spokenToken = index < spokenWords.length ? spokenWords[index] : '';
      final confidence =
          _wordConfidence(expectedToken, spokenToken, spokenWords.isEmpty);

      words.add(
        PronunciationWordFeedback(
          word: displayWord,
          confidence: confidence,
        ),
      );
    }

    if (words.isEmpty) {
      return PronunciationAssessmentResult(
        overallScore: 0,
        words: const [],
        transcript: spokenText,
      );
    }

    final overall =
        (words.map((w) => w.confidence).reduce((a, b) => a + b) / words.length)
            .round();

    return PronunciationAssessmentResult(
      overallScore: overall.clamp(0, 100),
      words: words,
      transcript: spokenText,
    );
  }

  List<String> _extractWords(String phrase) {
    final matches = RegExp(r"\b[\w']+\b").allMatches(phrase);
    return matches.map((match) => match.group(0)!).toList();
  }

  List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  int _wordConfidence(String expected, String spoken, bool noSpeech) {
    if (noSpeech) return 35;
    if (spoken.isEmpty) return 42;
    if (expected == spoken) return 96;

    final similarity = _similarity(expected, spoken);
    if (similarity >= 0.85) return 90;
    if (similarity >= 0.65) return 78;
    if (similarity >= 0.45) return 65;
    return (similarity * 100).round().clamp(40, 60);
  }

  double _similarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1;
    if (a.isEmpty || b.isEmpty) return 0;
    final distance = _levenshtein(a, b);
    final maxLen = math.max(a.length, b.length);
    return 1 - (distance / maxLen);
  }

  int _levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final previous = List<int>.generate(b.length + 1, (index) => index);
    final current = List<int>.filled(b.length + 1, 0);

    for (var i = 0; i < a.length; i++) {
      current[0] = i + 1;
      for (var j = 0; j < b.length; j++) {
        final cost = a[i] == b[j] ? 0 : 1;
        current[j + 1] = math.min(
          math.min(current[j] + 1, previous[j + 1] + 1),
          previous[j] + cost,
        );
      }
      for (var j = 0; j < previous.length; j++) {
        previous[j] = current[j];
      }
    }

    return previous[b.length];
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
