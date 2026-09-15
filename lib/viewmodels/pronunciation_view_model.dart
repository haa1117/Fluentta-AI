import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/data/models/pronunciation_phrase_model.dart';
import 'package:fluentta_ai/data/services/ai_backend_service.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class PronunciationViewModel extends ChangeNotifier {
  PronunciationViewModel(
    this._homeViewModel,
    this._textToSpeechService,
    this._assessmentService,
    this._progressSyncService,
    this._aiBackendService,
  );

  final HomeViewModel _homeViewModel;
  final TextToSpeechService _textToSpeechService;
  final PronunciationAssessmentService _assessmentService;
  final ProgressSyncService _progressSyncService;
  final AiBackendService _aiBackendService;
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSub;
  PronunciationStartFailure _startFailure = PronunciationStartFailure.none;

  int _currentPhraseIndex = 0;
  final List<int> _completedScores = [];
  final List<PronunciationAssessmentResult> _phraseResults = [];
  PronunciationAssessmentResult? _currentResult;
  bool _isRecording = false;
  bool _isListeningPhrase = false;
  bool _isAssessing = false;
  double _soundLevel = 0;
  String _deviceTranscript = '';
  Uint8List? _pendingAudio;
  String _pendingMimeType = 'audio/mp4';
  String _pendingFilename = 'speech.m4a';

  int get lives => _homeViewModel.lives;
  int get currentPhraseIndex => _currentPhraseIndex;
  int get totalPhrases => PronunciationContent.phrases.length;
  bool get isLastPhrase => _currentPhraseIndex >= totalPhrases - 1;
  bool get isRecording => _isRecording;
  bool get isListeningPhrase => _isListeningPhrase;
  bool get isAssessing => _isAssessing;
  double get soundLevel => _soundLevel;
  bool get canAffordCheck =>
      _homeViewModel.hasUnlimitedHearts || lives > 0;

  String get currentPhraseText =>
      PronunciationContent.phrases[_currentPhraseIndex].text;

  PronunciationAssessmentResult? get currentResult => _currentResult;

  int get averageScore {
    if (_completedScores.isEmpty) return 0;
    final sum = _completedScores.reduce((a, b) => a + b);
    return (sum / _completedScores.length).round();
  }

  String get bestWord {
    var best = '';
    var bestScore = 0;
    for (final result in _phraseResults) {
      for (final word in result.words) {
        if (word.confidence > bestScore) {
          bestScore = word.confidence;
          best = word.word;
        }
      }
    }
    if (best.isNotEmpty) return best;
    return _extractWords(currentPhraseText).firstOrNull ?? '';
  }

  Future<bool> deductHeartForCheck() async {
    if (_homeViewModel.hasUnlimitedHearts) return true;
    if (!canAffordCheck) return false;
    return _homeViewModel.useHeart();
  }

  Future<bool> listenToCurrentPhrase() async {
    await _textToSpeechService.stop();
    _isListeningPhrase = true;
    notifyListeners();

    final didSpeak = await _textToSpeechService.speak(
      currentPhraseText,
      onComplete: () {
        _isListeningPhrase = false;
        notifyListeners();
      },
    );

    if (!didSpeak) {
      _isListeningPhrase = false;
      notifyListeners();
    }
    return didSpeak;
  }

  PronunciationStartFailure get lastStartFailure =>
      _startFailure != PronunciationStartFailure.none
          ? _startFailure
          : _assessmentService.lastStartFailure;

  Future<bool> startRecording() async {
    _startFailure = PronunciationStartFailure.none;
    _currentResult = null;
    _soundLevel = 0;
    _deviceTranscript = '';
    _pendingAudio = null;
    _isRecording = true;
    notifyListeners();

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      _startFailure = PronunciationStartFailure.permissionDenied;
      _isRecording = false;
      notifyListeners();
      return false;
    }

    try {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/fluenta_pronunciation_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
        path: path,
      );
      await _amplitudeSub?.cancel();
      _amplitudeSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 160))
          .listen((amp) {
        _soundLevel = ((amp.current + 50) / 50).clamp(0, 1);
        notifyListeners();
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioRecorder start failed: $e');
      }
      final started = await _assessmentService.startListening(
        onSoundLevel: (level) {
          _soundLevel = level;
          notifyListeners();
        },
      );
      if (!started) {
        _isRecording = false;
        notifyListeners();
      }
      return started;
    }
  }

  Future<void> finishRecording() async {
    await _amplitudeSub?.cancel();
    _amplitudeSub = null;
    _isRecording = false;
    notifyListeners();

    try {
      final path = await _recorder.stop();
      if (path != null && path.isNotEmpty) {
        final file = File(path);
        if (await file.exists()) {
          _pendingAudio = await file.readAsBytes();
          _pendingMimeType = 'audio/mp4';
          _pendingFilename = 'speech.m4a';
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioRecorder stop failed: $e');
      }
    }

    if (_assessmentService.isListening) {
      _deviceTranscript = await _assessmentService.stopListening();
    }
  }

  Future<PronunciationAssessmentResult?> assessPendingTake() async {
    if (_currentResult != null || _isAssessing) return _currentResult;
    _isAssessing = true;
    notifyListeners();

    var spokenText = _deviceTranscript.trim();
    final audio = _pendingAudio;
    if (audio != null && audio.isNotEmpty) {
      try {
        final transcript = await _aiBackendService.transcribePronunciation(
          audioBytes: audio,
          mimeType: _pendingMimeType,
          filename: _pendingFilename,
          expectedPhrase: currentPhraseText,
        );
        if (transcript.isNotEmpty) {
          spokenText = transcript;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Whisper assess failed, using on-device transcript: $e');
        }
      }
    }

    final result = _assessmentService.assess(
      expectedPhrase: currentPhraseText,
      spokenText: spokenText,
    );
    _currentResult = result;
    _pendingAudio = null;
    _isAssessing = false;

    await _progressSyncService.recordCorrections(result.correctionCount);
    notifyListeners();
    return result;
  }

  Future<PronunciationAssessmentResult?> stopRecordingAndAssess() async {
    await finishRecording();
    return assessPendingTake();
  }

  void cancelRecording() {
    _amplitudeSub?.cancel();
    _amplitudeSub = null;
    _assessmentService.cancelListening();
    _recorder.stop();
    _isRecording = false;
    _soundLevel = 0;
    _pendingAudio = null;
    notifyListeners();
  }

  void clearCurrentResult() {
    _currentResult = null;
    notifyListeners();
  }

  void completeCurrentPhrase() {
    final result = _currentResult;
    if (result == null) return;

    if (_completedScores.length > _currentPhraseIndex) {
      _completedScores[_currentPhraseIndex] = result.overallScore;
      if (_phraseResults.length > _currentPhraseIndex) {
        _phraseResults[_currentPhraseIndex] = result;
      } else {
        _phraseResults.add(result);
      }
    } else if (_completedScores.length == _currentPhraseIndex) {
      _completedScores.add(result.overallScore);
      _phraseResults.add(result);
    }
    notifyListeners();
  }

  void nextPhrase() {
    if (!isLastPhrase) {
      _currentPhraseIndex++;
      _currentResult = null;
      notifyListeners();
    }
  }

  void resetSession() {
    _currentPhraseIndex = 0;
    _completedScores.clear();
    _phraseResults.clear();
    _currentResult = null;
    _isRecording = false;
    _soundLevel = 0;
    _pendingAudio = null;
    _assessmentService.cancelListening();
    _recorder.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    _assessmentService.cancelListening();
    _amplitudeSub?.cancel();
    _recorder.dispose();
    _textToSpeechService.stop();
    super.dispose();
  }

  List<String> _extractWords(String phrase) {
    return RegExp(r"\b[\w']+\b")
        .allMatches(phrase)
        .map((match) => match.group(0)!)
        .toList();
  }
}

extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
