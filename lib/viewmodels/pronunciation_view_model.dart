import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/utils/simple_uuid.dart';
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
  ) : practiceSessionId = generateUuidV4();

  final HomeViewModel _homeViewModel;
  final TextToSpeechService _textToSpeechService;
  final PronunciationAssessmentService _assessmentService;
  final ProgressSyncService _progressSyncService;
  final AiBackendService _aiBackendService;
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSub;
  Timer? _recordingLimitTimer;
  PronunciationStartFailure _startFailure = PronunciationStartFailure.none;
  final String practiceSessionId;
  DateTime? _recordingStartedAt;
  final Map<int, int> _attemptsByPhrase = {};

  /// Short office phrases do not need a long take. Caps STT cost and
  /// keeps the practice beat tight.
  static const Duration maxRecordingDuration = Duration(seconds: 10);

  int _currentPhraseIndex = 0;
  final List<int> _completedScores = [];
  final List<PronunciationAssessmentResult> _phraseResults = [];
  PronunciationAssessmentResult? _currentResult;
  bool _isRecording = false;
  bool _isListeningPhrase = false;
  bool _isAssessing = false;
  bool _lastCheckFailed = false;
  bool _heartRefunded = false;
  double _soundLevel = 0;
  String _deviceTranscript = '';
  Uint8List? _pendingAudio;
  String _pendingMimeType = 'audio/mp4';
  String _pendingFilename = 'speech.m4a';
  int _recordingElapsedMs = 0;
  bool _autoStoppingRecording = false;

  /// Set by the recording screen so a max-duration stop can navigate onward.
  VoidCallback? onRecordingAutoStopped;

  int get lives => _homeViewModel.lives;
  int get currentPhraseIndex => _currentPhraseIndex;
  int get totalPhrases => PronunciationContent.phrases.length;
  bool get isLastPhrase => _currentPhraseIndex >= totalPhrases - 1;
  bool get isRecording => _isRecording;
  bool get isListeningPhrase => _isListeningPhrase;
  bool get isAssessing => _isAssessing;

  /// Whole seconds left before the take is auto-submitted.
  int get recordingRemainingSeconds {
    final left = maxRecordingDuration.inMilliseconds - _recordingElapsedMs;
    return (left / 1000).ceil().clamp(0, maxRecordingDuration.inSeconds);
  }

  /// True when the last check could not be scored (no fake score is shown).
  bool get lastCheckFailed => _lastCheckFailed;
  double get soundLevel => _soundLevel;
  bool get canAffordCheck =>
      _homeViewModel.hasUnlimitedHearts || lives > 0;

  String get currentPhraseText =>
      PronunciationContent.phrases[_currentPhraseIndex].text;

  int get currentPhraseNumber => _currentPhraseIndex + 1;

  String get currentPhraseId => 'phrase_$currentPhraseNumber';

  int get currentAttemptNumber =>
      _attemptsByPhrase[_currentPhraseIndex] ?? 0;

  Map<String, Object?> phraseAnalyticsParams({int? attemptNumber}) => {
        AnalyticsParams.practiceSessionId: practiceSessionId,
        AnalyticsParams.phraseId: currentPhraseId,
        AnalyticsParams.phraseNumber: currentPhraseNumber,
        AnalyticsParams.phraseCount: totalPhrases,
        AnalyticsParams.pronunciationAttemptNumber:
            attemptNumber ?? currentAttemptNumber,
      };

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

  /// Kicks off the mic permission check ahead of time (e.g. while the
  /// recording screen is still transitioning in) so startRecording() on that
  /// screen doesn't have to wait on it — that wait was the visible delay
  /// before the recording UI could show.
  void primeMicrophonePermission() {
    unawaited(_recorder.hasPermission());
  }

  Future<bool> deductHeartForCheck() async {
    _heartRefunded = false;
    // Pro (unlimited hearts) is the only bypass. Debug builds spend real
    // hearts too — use the Profile screen's debug "Add hearts"/"Enable
    // Pro" tools to test without running out.
    if (_homeViewModel.hasUnlimitedHearts) return true;
    if (!canAffordCheck) return false;
    return _homeViewModel.useHeart();
  }

  Future<bool> listenToCurrentPhrase() async {
    await _textToSpeechService.stop();
    _isListeningPhrase = true;
    notifyListeners();
    AnalyticsService.instance.log(
      AnalyticsEvents.pronunciationPhraseAudioPlayed,
      phraseAnalyticsParams(),
    );

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
    _lastCheckFailed = false;
    _soundLevel = 0;
    _deviceTranscript = '';
    _pendingAudio = null;
    _recordingElapsedMs = 0;
    _autoStoppingRecording = false;
    _cancelRecordingLimit();
    _isRecording = true;
    notifyListeners();

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      _startFailure = PronunciationStartFailure.permissionDenied;
      _isRecording = false;
      _cancelRecordingLimit();
      notifyListeners();
      AnalyticsService.instance.log(
        AnalyticsEvents.pronunciationRecordingFailed,
        {
          ...phraseAnalyticsParams(),
          AnalyticsParams.errorType: 'permission',
          AnalyticsParams.errorCode: 'permission_denied',
          AnalyticsParams.failureStage: 'microphone_capture',
          AnalyticsParams.microphonePermission: 'denied',
        },
      );
      return false;
    }

    try {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/fluenta_pronunciation_${DateTime.now().millisecondsSinceEpoch}.wav';
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: path,
      );
      await _amplitudeSub?.cancel();
      _amplitudeSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 160))
          .listen((amp) {
        _soundLevel = ((amp.current + 50) / 50).clamp(0, 1);
        notifyListeners();
      });
      _attemptsByPhrase[_currentPhraseIndex] =
          (_attemptsByPhrase[_currentPhraseIndex] ?? 0) + 1;
      _armRecordingLimit();
      AnalyticsService.instance.log(
        AnalyticsEvents.pronunciationRecordingStarted,
        {
          ...phraseAnalyticsParams(),
          AnalyticsParams.microphonePermission: 'granted',
        },
      );
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
        maxListenFor: maxRecordingDuration,
      );
      if (!started) {
        _isRecording = false;
        _cancelRecordingLimit();
        notifyListeners();
        AnalyticsService.instance.log(
          AnalyticsEvents.pronunciationRecordingFailed,
          {
            ...phraseAnalyticsParams(),
            AnalyticsParams.errorType: 'configuration',
            AnalyticsParams.errorCode: 'recorder_unavailable',
            AnalyticsParams.failureStage: 'microphone_capture',
            AnalyticsParams.microphonePermission: 'granted',
          },
        );
      } else {
        _attemptsByPhrase[_currentPhraseIndex] =
            (_attemptsByPhrase[_currentPhraseIndex] ?? 0) + 1;
        _armRecordingLimit();
        AnalyticsService.instance.log(
          AnalyticsEvents.pronunciationRecordingStarted,
          {
            ...phraseAnalyticsParams(),
            AnalyticsParams.microphonePermission: 'granted',
          },
        );
      }
      return started;
    }
  }

  void _armRecordingLimit() {
    _cancelRecordingLimit();
    _recordingStartedAt = DateTime.now();
    _recordingElapsedMs = 0;
    _recordingLimitTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (_recordingStartedAt == null || !_isRecording) {
        _cancelRecordingLimit();
        return;
      }
      _recordingElapsedMs =
          DateTime.now().difference(_recordingStartedAt!).inMilliseconds;
      notifyListeners();
      if (_recordingElapsedMs >= maxRecordingDuration.inMilliseconds) {
        unawaited(_autoStopAtMaxDuration());
      }
    });
  }

  void _cancelRecordingLimit() {
    _recordingLimitTimer?.cancel();
    _recordingLimitTimer = null;
  }

  Future<void> _autoStopAtMaxDuration() async {
    if (!_isRecording || _autoStoppingRecording) return;
    _autoStoppingRecording = true;
    _cancelRecordingLimit();
    notifyListeners();
    final callback = onRecordingAutoStopped;
    if (callback != null) {
      callback();
    } else {
      await finishRecording();
    }
  }

  Future<void> finishRecording() async {
    _cancelRecordingLimit();
    _autoStoppingRecording = true;
    final durationMs = _recordingStartedAt == null
        ? 0
        : DateTime.now().difference(_recordingStartedAt!).inMilliseconds;
    _recordingStartedAt = null;
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
          final isWav = path.toLowerCase().endsWith('.wav');
          _pendingMimeType = isWav ? 'audio/wav' : 'audio/mp4';
          _pendingFilename = isWav ? 'speech.wav' : 'speech.m4a';
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
    AnalyticsService.instance.log(
      AnalyticsEvents.pronunciationRecordingCompleted,
      {
        ...phraseAnalyticsParams(),
        AnalyticsParams.captureDurationMs: durationMs < 0 ? 0 : durationMs,
      },
    );
  }

  Future<PronunciationAssessmentResult?> assessPendingTake({
    String? feedbackLanguage,
  }) async {
    if (_currentResult != null || _isAssessing) return _currentResult;
    _isAssessing = true;
    _lastCheckFailed = false;
    notifyListeners();
    final checkStartedAt = DateTime.now();

    Object? backendError;
    final audio = _pendingAudio;
    if (audio != null && audio.isNotEmpty) {
      try {
        final result = await _aiBackendService.assessPronunciation(
          audioBytes: audio,
          mimeType: _pendingMimeType,
          filename: _pendingFilename,
          expectedPhrase: currentPhraseText,
          feedbackLanguage: feedbackLanguage,
        );
        return await _finishAssessment(result, checkStartedAt);
      } catch (e) {
        backendError = e;
        if (kDebugMode) {
          debugPrint('Pronunciation backend failed: $e');
        }
      }
    }

    // Only fall back to the on-device text match when speech-to-text actually
    // produced a transcript. Scoring an empty transcript would report
    // "nothing heard" for a learner who spoke perfectly.
    final deviceText = _deviceTranscript.trim();
    if (deviceText.isNotEmpty) {
      final result = _assessmentService.assess(
        expectedPhrase: currentPhraseText,
        spokenText: deviceText,
      );
      return _finishAssessment(result, checkStartedAt);
    }

    await _failCheck(backendError);
    return null;
  }

  Future<PronunciationAssessmentResult> _finishAssessment(
    PronunciationAssessmentResult result,
    DateTime checkStartedAt,
  ) async {
    _currentResult = result;
    _pendingAudio = null;
    _isAssessing = false;
    await _progressSyncService.recordCorrections(result.correctionCount);
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.pronunciationCheckSucceeded, {
      ...phraseAnalyticsParams(),
      AnalyticsParams.overallScore: result.overallScore,
      AnalyticsParams.speechDetected: result.heardAnything,
      AnalyticsParams.wordFeedbackCount: result.words.length,
      AnalyticsParams.latencyMs:
          DateTime.now().difference(checkStartedAt).inMilliseconds,
    });
    return result;
  }

  /// The check could not be scored: return the heart and let the screen ask
  /// the learner to try again instead of showing a made-up score.
  Future<void> _failCheck(Object? error) async {
    _isAssessing = false;
    _lastCheckFailed = true;
    _pendingAudio = null;
    if (!_heartRefunded && !_homeViewModel.hasUnlimitedHearts) {
      _heartRefunded = true;
      await _homeViewModel.addHearts(1);
    }
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.pronunciationCheckFailed, {
      ...phraseAnalyticsParams(),
      AnalyticsParams.errorType: 'backend',
      AnalyticsParams.errorCode: error == null ? 'no_audio' : 'backend_error',
      AnalyticsParams.failureStage: 'model_response',
    });
  }

  Future<PronunciationAssessmentResult?> stopRecordingAndAssess({
    String? feedbackLanguage,
  }) async {
    await finishRecording();
    return assessPendingTake(feedbackLanguage: feedbackLanguage);
  }

  void cancelRecording() {
    _cancelRecordingLimit();
    _autoStoppingRecording = true;
    final durationMs = _recordingStartedAt == null
        ? 0
        : DateTime.now().difference(_recordingStartedAt!).inMilliseconds;
    _recordingStartedAt = null;
    _amplitudeSub?.cancel();
    _amplitudeSub = null;
    _assessmentService.cancelListening();
    _recorder.stop();
    _isRecording = false;
    _soundLevel = 0;
    _pendingAudio = null;
    notifyListeners();
    AnalyticsService.instance.log(
      AnalyticsEvents.pronunciationRecordingCancelled,
      {
        ...phraseAnalyticsParams(),
        AnalyticsParams.captureDurationMs: durationMs < 0 ? 0 : durationMs,
      },
    );
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
    _cancelRecordingLimit();
    _assessmentService.cancelListening();
    _recorder.stop();
    _attemptsByPhrase.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    onRecordingAutoStopped = null;
    _cancelRecordingLimit();
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
