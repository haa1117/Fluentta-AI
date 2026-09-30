import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/tutor_chat_models.dart';
import 'package:fluentta_ai/data/services/ai_backend_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Simple v4-shaped random id (no `uuid` package dependency) — stable for
/// the lifetime of one Open Chat Practice session, used to correlate every
/// analytics event fired during this conversation.
String _generateConversationId() {
  final random = Random();
  const chars = '0123456789abcdef';
  String hex(int length) =>
      List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${chars[8 + random.nextInt(4)]}${hex(3)}-${hex(12)}';
}

/// Which input surface is currently shown at the bottom of the chat.
enum ChatInputMode { text, voice }

/// Lifecycle of a voice capture while [ChatInputMode.voice] is active.
enum VoiceCaptureState {
  /// Nothing is being recorded — the big "Hold to Speak" mic is shown.
  idle,

  /// The user is holding the mic and can still slide to cancel or lock.
  recording,

  /// Recording was locked hands-free — the user taps the mic to send.
  locked,
}

/// Quick prompt suggestions shown before the first user message.
enum ChatQuickStarter { daily, work, travel, grammar, openTopic }

class OpenChatViewModel extends ChangeNotifier {
  OpenChatViewModel({
    required HomeViewModel homeViewModel,
    required AiBackendService aiBackendService,
    required PronunciationAssessmentService speechService,
    required ProgressSyncService progressSyncService,
    required TextToSpeechService textToSpeechService,
    required LocalStorage localStorage,
    required String greeting,
    String? cefrLevel,
    String? goal,
    String? nativeLanguage,
    Connectivity? connectivity,
  })  : _homeViewModel = homeViewModel,
        _aiBackendService = aiBackendService,
        _speechService = speechService,
        _progressSyncService = progressSyncService,
        _tts = textToSpeechService,
        _localStorage = localStorage,
        _cefrLevel = cefrLevel,
        _goal = goal,
        _nativeLanguage = nativeLanguage,
        _connectivity = connectivity ?? Connectivity() {
    _speakReplies = _localStorage.chatSpeakRepliesEnabled;
    _messages.add(
      OpenChatMessage(isUser: false, text: greeting),
    );
    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      final online = NetworkStatus.hasConnection(results);
      if (_isOnline == online) return;
      _isOnline = online;
      notifyListeners();
    });
    unawaited(_refreshOnline());
  }

  final HomeViewModel _homeViewModel;
  final AiBackendService _aiBackendService;
  final PronunciationAssessmentService _speechService;
  final ProgressSyncService _progressSyncService;
  final TextToSpeechService _tts;
  final LocalStorage _localStorage;
  final Connectivity _connectivity;
  final AudioRecorder _recorder = AudioRecorder();
  final String? _cefrLevel;
  final String? _goal;
  final String? _nativeLanguage;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  /// Stable for this chat session — generated once, preserved across mode
  /// switches, threaded through every AI Chat analytics event.
  final String conversationId = _generateConversationId();

  /// Per-conversation-turn counter (`message_sequence`), incremented once per
  /// user-submitted message regardless of input method.
  int _messageSequence = 0;

  /// The topic of the next message to submit — set by a tapped quick
  /// starter, otherwise 'open_topic' for free-form input.
  String _pendingTopicType = 'open_topic';

  bool _loggedExit = false;

  final List<OpenChatMessage> _messages = [];
  ChatInputMode _inputMode = ChatInputMode.text;
  VoiceCaptureState _voiceState = VoiceCaptureState.idle;
  bool _isSending = false;
  bool _isTranscribing = false;
  bool _speakReplies = true;
  bool _isOnline = true;
  int? _speakingIndex;
  String? _error;

  // When the learner sent their first message this session — used to credit
  // the daily goal with real elapsed time on dispose, instead of a flat
  // per-open amount.
  DateTime? _sessionStartedAt;

  // Voice capture: we record an audio file and send it to the transcription
  // service. The on-device recognizer is only a fallback when recording fails.
  String? _recordPath;
  bool _sttFallbackActive = false;

  static const List<ChatQuickStarter> quickStarters = ChatQuickStarter.values;

  List<OpenChatMessage> get messages => List.unmodifiable(_messages);
  ChatInputMode get inputMode => _inputMode;
  VoiceCaptureState get voiceState => _voiceState;
  bool get isSending => _isSending;

  /// True while a finished voice recording is being converted to text.
  bool get isTranscribing => _isTranscribing;

  String? get error => _error;

  /// Tutor chat and cloud transcription require a network connection.
  bool get isOnline => _isOnline;

  /// Whether the tutor's replies are read aloud automatically.
  bool get speakReplies => _speakReplies;

  /// Index into [messages] of the bubble currently being spoken, or null.
  int? get speakingIndex => _speakingIndex;

  /// The quick starters only make sense until the learner has said something.
  bool get showQuickStarters =>
      !_messages.any((message) => message.isUser);

  /// 'text'/'voice' — the catalogue's `communication_mode` value.
  String get _communicationModeValue =>
      _inputMode == ChatInputMode.text ? 'text' : 'voice';

  /// 'metered'/'unlimited' — the catalogue's `heart_access_type` value.
  String get _heartAccessTypeValue =>
      _homeViewModel.hasUnlimitedHearts ? 'unlimited' : 'metered';

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  void setInputMode(ChatInputMode mode) {
    if (_inputMode == mode) return;
    final fromMode = _communicationModeValue;
    _inputMode = mode;
    AnalyticsService.instance.log(AnalyticsEvents.aiChatModeChanged, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.fromMode: fromMode,
      AnalyticsParams.toMode: _communicationModeValue,
      AnalyticsParams.messageCount: _messages.length,
    });
    if (mode == ChatInputMode.text && _voiceState != VoiceCaptureState.idle) {
      unawaited(cancelVoiceCapture());
    }
    if (mode == ChatInputMode.voice) {
      // Ask for mic permission now, as soon as the voice panel appears —
      // not on the first press. Requesting it inside beginVoiceCapture()
      // raced with the hold-to-speak gesture: the OS permission dialog
      // steals touch focus, the finger lift fires before the request
      // resolves, and the panel is left stuck. Priming here means the OS
      // dialog (if any) is long resolved before the user can press the mic.
      unawaited(_recorder.hasPermission());
    }
    notifyListeners();
  }

  /// Records the topic of a suggested-topic tap so the next
  /// `ai_chat_message_submitted` reports it, and fires
  /// `ai_chat_topic_selected` immediately.
  void selectTopic(String topicType) {
    _pendingTopicType = topicType;
    AnalyticsService.instance.log(AnalyticsEvents.aiChatTopicSelected, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.topicType: topicType,
      AnalyticsParams.communicationMode: _communicationModeValue,
    });
  }

  // --- Speech output (tutor reads its replies aloud) ----------------------

  Future<void> toggleSpeakReplies() async {
    final fromState = _speakReplies ? 'unmuted' : 'muted';
    _speakReplies = !_speakReplies;
    notifyListeners();
    await _localStorage.setChatSpeakRepliesEnabled(_speakReplies);
    AnalyticsService.instance.log(AnalyticsEvents.aiResponseAudioToggled, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.fromAudioState: fromState,
      AnalyticsParams.toAudioState: _speakReplies ? 'unmuted' : 'muted',
      AnalyticsParams.communicationMode: _communicationModeValue,
    });
    if (!_speakReplies) {
      await _stopSpeaking();
    }
  }

  /// Play, or stop if it is already playing, the bubble at [index]. This is
  /// always a manual tap (the automatic post-reply playback calls [_speak]
  /// directly), so it's the trigger for `ai_response_play_clicked`.
  Future<void> speakMessage(int index) async {
    if (index < 0 || index >= _messages.length) return;
    if (_speakingIndex == index) {
      await _stopSpeaking();
      return;
    }
    final message = _messages[index];
    AnalyticsService.instance.log(AnalyticsEvents.aiResponsePlayClicked, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.messageSequence: message.sequence,
      AnalyticsParams.communicationMode: _communicationModeValue,
      AnalyticsParams.responseAudioState: _speakReplies ? 'unmuted' : 'muted',
      AnalyticsParams.playbackSource: 'manual_play',
    });
    await _speak(index, message.text, playbackSource: 'manual_play');
  }

  Future<void> _speak(
    int index,
    String text, {
    String playbackSource = 'automatic',
  }) async {
    if (text.trim().isEmpty) return;
    _speakingIndex = index;
    notifyListeners();
    final sequence = index >= 0 && index < _messages.length
        ? _messages[index].sequence
        : null;
    // The TTS service's speak() only resolves once playback has finished (or
    // failed) — there's no earlier "audio actually began" callback without
    // changing TextToSpeechService itself (out of this pass's scope), so
    // `ai_response_audio_started`/`_failed` are fired from that single
    // result instead of from a true playback-start signal.
    final played = await _tts.speak(
      text,
      languageCode: _nativeLanguage,
      onComplete: () {
        if (_speakingIndex == index) {
          _speakingIndex = null;
          notifyListeners();
        }
      },
    );
    if (played) {
      AnalyticsService.instance.log(AnalyticsEvents.aiResponseAudioStarted, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: sequence,
        AnalyticsParams.communicationMode: _communicationModeValue,
        AnalyticsParams.playbackSource: playbackSource,
      });
    } else {
      AnalyticsService.instance.log(AnalyticsEvents.aiResponseAudioFailed, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: sequence,
        AnalyticsParams.playbackSource: playbackSource,
        AnalyticsParams.errorType: 'playback_error',
        AnalyticsParams.errorCode: 'tts_failed',
      });
    }
  }

  Future<void> _stopSpeaking() async {
    if (_speakingIndex == null) return;
    _speakingIndex = null;
    notifyListeners();
    await _tts.stop();
  }

  Future<void> sendQuickStarter(String prompt) => sendText(prompt);

  Future<void> sendText(String raw) async {
    final text = raw.trim();
    if (text.isEmpty || _isSending) return;
    if (!await _ensureOnline()) return;
    await _sendUserText(text, inputMethod: 'keyboard');
  }

  // --- Voice capture -------------------------------------------------------

  /// Bumped every time a capture starts/ends so a slow [beginVoiceCapture]
  /// (e.g. still waiting on the OS permission dialog) can tell whether the
  /// user already released/cancelled before it finished, instead of landing
  /// the panel in "recording" with no press left to end it.
  int _captureGeneration = 0;

  /// When the current/most-recent voice capture began — used for
  /// `capture_duration_ms` on completed/cancelled/failed events.
  DateTime? _captureStartedAt;

  Future<void> beginVoiceCapture() async {
    if (_isSending || _voiceState != VoiceCaptureState.idle) return;
    if (!await _ensureOnline()) return;
    final generation = ++_captureGeneration;
    // Don't let the tutor's voice bleed into the microphone.
    await _stopSpeaking();
    _sttFallbackActive = false;
    _recordPath = null;

    var started = false;
    var micPermissionGranted = false;
    try {
      micPermissionGranted = await _recorder.hasPermission();
      if (micPermissionGranted) {
        if (generation != _captureGeneration) {
          // The user already released/cancelled while the permission
          // prompt was up — don't start a recording nobody asked for.
          unawaited(_recorder.stop());
          return;
        }
        final dir = await getTemporaryDirectory();
        _recordPath =
            '${dir.path}/fluenta_chat_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc, numChannels: 1),
          path: _recordPath!,
        );
        started = true;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('chat recorder start failed: $e');
      _recordPath = null;
    }

    if (generation != _captureGeneration) {
      // Superseded while awaiting the recorder/STT — undo whatever just
      // started so we don't leave the panel showing a phantom recording.
      if (started) {
        if (_sttFallbackActive) {
          _speechService.cancelListening();
        } else {
          unawaited(_recorder.stop());
        }
        _deleteRecording(_recordPath);
        _recordPath = null;
      }
      return;
    }

    if (!started) {
      // No recorder — use the on-device recognizer for this capture only.
      started = await _speechService.startListening();
      _sttFallbackActive = started;
    }

    if (generation != _captureGeneration) {
      if (started) {
        _speechService.cancelListening();
      }
      return;
    }

    if (started) {
      _captureStartedAt = DateTime.now();
      _voiceState = VoiceCaptureState.recording;
      AnalyticsService.instance.log(AnalyticsEvents.voiceCaptureStarted, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: _messageSequence + 1,
        AnalyticsParams.microphonePermission:
            micPermissionGranted ? 'granted' : 'denied',
      });
    } else {
      _voiceState = VoiceCaptureState.idle;
      _error = 'speech_unavailable';
      AnalyticsService.instance.log(AnalyticsEvents.voiceCaptureFailed, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: _messageSequence + 1,
        AnalyticsParams.failureStage: 'microphone_capture',
        AnalyticsParams.errorType: 'capture_unavailable',
        AnalyticsParams.errorCode: 'no_recorder_or_stt',
        AnalyticsParams.microphonePermission:
            micPermissionGranted ? 'granted' : 'denied',
      });
    }
    notifyListeners();
  }

  void lockVoiceCapture() {
    if (_voiceState != VoiceCaptureState.recording) return;
    _voiceState = VoiceCaptureState.locked;
    notifyListeners();
  }

  int get _captureDurationMs {
    final startedAt = _captureStartedAt;
    if (startedAt == null) return 0;
    return DateTime.now().difference(startedAt).inMilliseconds;
  }

  Future<void> cancelVoiceCapture() async {
    // Bump even if we're still idle — a beginVoiceCapture() may still be
    // awaiting mic permission or the recorder/STT start, and needs to see
    // that it was cancelled once it comes back.
    _captureGeneration++;
    if (_voiceState == VoiceCaptureState.idle) return;
    if (_sttFallbackActive) {
      _speechService.cancelListening();
    } else {
      try {
        await _recorder.stop();
      } catch (_) {}
    }
    _deleteRecording(_recordPath);
    _recordPath = null;
    _sttFallbackActive = false;
    _voiceState = VoiceCaptureState.idle;
    AnalyticsService.instance.log(AnalyticsEvents.voiceCaptureCancelled, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.messageSequence: _messageSequence + 1,
      AnalyticsParams.captureDurationMs: _captureDurationMs,
    });
    notifyListeners();
  }

  Future<void> finishVoiceCapture() async {
    if (_voiceState == VoiceCaptureState.idle) {
      // Same race as cancelVoiceCapture(): the press may have already
      // released while beginVoiceCapture() was still awaiting mic
      // permission. Nothing to send yet — just make sure it doesn't
      // silently start a recording after the finger is already gone.
      _captureGeneration++;
      return;
    }
    if (!await _ensureOnline()) {
      await cancelVoiceCapture();
      _error = 'offline';
      notifyListeners();
      return;
    }

    String text;
    if (_sttFallbackActive) {
      text = (await _speechService.stopListening()).trim();
      _sttFallbackActive = false;
      _voiceState = VoiceCaptureState.idle;
      notifyListeners();
    } else {
      String? path;
      try {
        path = await _recorder.stop();
      } catch (_) {}
      _voiceState = VoiceCaptureState.idle;
      _isTranscribing = true;
      notifyListeners();
      text = await _transcribeRecording(path ?? _recordPath);
      _recordPath = null;
      _isTranscribing = false;
      notifyListeners();
    }

    if (text.isNotEmpty) {
      AnalyticsService.instance.log(AnalyticsEvents.voiceCaptureCompleted, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: _messageSequence + 1,
        AnalyticsParams.captureDurationMs: _captureDurationMs,
      });
      await _sendUserText(text, inputMethod: 'microphone');
    } else {
      _error = 'speech_unavailable';
      AnalyticsService.instance.log(AnalyticsEvents.voiceCaptureFailed, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: _messageSequence + 1,
        AnalyticsParams.failureStage: 'transcription',
        AnalyticsParams.errorType: 'empty_transcription',
        AnalyticsParams.errorCode: 'no_speech_detected',
        AnalyticsParams.microphonePermission: 'granted',
      });
      notifyListeners();
    }
  }

  Future<String> _transcribeRecording(String? path) async {
    if (path == null) return '';
    try {
      final file = File(path);
      if (!await file.exists()) return '';
      final bytes = await file.readAsBytes();
      if (bytes.length < 1200) return ''; // essentially silence
      final result = await _aiBackendService.transcribeSpeech(
        audioBytes: bytes,
        mimeType: 'audio/mp4',
        filename: 'speech.m4a',
      );
      return result.trim();
    } catch (e) {
      if (kDebugMode) debugPrint('chat transcription failed: $e');
      return '';
    } finally {
      _deleteRecording(path);
    }
  }

  void _deleteRecording(String? path) {
    if (path == null) return;
    try {
      final file = File(path);
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }

  // --- AI round trip -----------------------------------------------------

  /// Only Pro (unlimited hearts) bypasses the heart cost. Debug builds
  /// consume real hearts like a release build — use the Profile screen's
  /// "Enable Pro (debug)" / "Add hearts (debug)" tools to test without them.
  bool get _heartsBypassed => _homeViewModel.hasUnlimitedHearts;

  Future<bool> _refreshOnline() async {
    final online = await NetworkStatus.isOnline(_connectivity);
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
    }
    return online;
  }

  Future<bool> _ensureOnline() async {
    if (await _refreshOnline()) return true;
    _error = 'offline';
    notifyListeners();
    return false;
  }

  Future<void> _sendUserText(String text, {required String inputMethod}) async {
    if (!await _ensureOnline()) return;
    if (!_heartsBypassed && _homeViewModel.lives <= 0) {
      _error = 'out_of_hearts';
      notifyListeners();
      return;
    }

    final sequence = ++_messageSequence;
    final topicType = _pendingTopicType;
    // Only the message that actually triggered a topic tap should report
    // it — later free-form turns in the same conversation fall back to
    // open_topic instead of re-reporting the earlier topic forever.
    _pendingTopicType = 'open_topic';

    await _stopSpeaking();
    _error = null;
    _isSending = true;
    _messages.add(OpenChatMessage(isUser: true, text: text, sequence: sequence));
    notifyListeners();

    final heartBalanceBefore = _homeViewModel.lives;
    final heartAccessType = _heartAccessTypeValue;
    final estimatedHeartCost = _heartsBypassed ? 0 : 1;
    final communicationMode = _communicationModeValue;

    AnalyticsService.instance.log(AnalyticsEvents.aiChatMessageSubmitted, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.messageSequence: sequence,
      AnalyticsParams.communicationMode: communicationMode,
      AnalyticsParams.inputMethod: inputMethod,
      AnalyticsParams.topicType: topicType,
      AnalyticsParams.heartAccessType: heartAccessType,
      AnalyticsParams.heartCost: estimatedHeartCost,
      AnalyticsParams.heartBalanceBefore: heartBalanceBefore,
    });

    // A heart is spent only after a reply arrives. A timeout or any other
    // failed request leaves the balance unchanged.
    var charged = false;
    final requestStartedAt = DateTime.now();
    try {
      final history = <TutorChatTurn>[];
      for (final message in _messages.take(_messages.length - 1)) {
        if (message.text.trim().isEmpty) continue;
        history.add(
          TutorChatTurn(
            role: message.isUser ? 'user' : 'assistant',
            content: message.text,
          ),
        );
      }

      final reply = await _aiBackendService.tutorChat(
        userText: text,
        history: history,
        cefrLevel: _cefrLevel,
        goal: _goal,
        nativeLanguage: _nativeLanguage,
      );

      if (!_heartsBypassed) {
        charged = await _homeViewModel.useHeart();
        if (!charged) {
          _error = 'out_of_hearts';
          return;
        }
      }
      _homeViewModel.maybeLogHeartGateRecovery(
        featureContext: 'ai_chat',
        blockedAction: 'submit_ai_chat_message',
      );

      final replyText = reply.tutorReply.isEmpty
          ? reply.correctedText
          : reply.tutorReply;
      _messages.add(
        OpenChatMessage(
          isUser: false,
          text: replyText,
          correctedText: reply.isCorrect ? null : reply.correctedText,
          explanation:
              reply.explanation.isEmpty ? null : reply.explanation,
          isCorrect: reply.isCorrect,
          sequence: sequence,
        ),
      );

      final hasCorrection =
          !reply.isCorrect && reply.correctedText.trim().isNotEmpty;
      AnalyticsService.instance.log(AnalyticsEvents.aiChatResponseReceived, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: sequence,
        AnalyticsParams.communicationMode: communicationMode,
        AnalyticsParams.latencyMs:
            DateTime.now().difference(requestStartedAt).inMilliseconds,
        AnalyticsParams.correctionState:
            hasCorrection ? 'shown' : 'not_needed',
        AnalyticsParams.heartCost: charged ? 1 : 0,
        AnalyticsParams.heartBalanceAfter: _homeViewModel.lives,
        AnalyticsParams.automaticAudioState:
            _speakReplies ? 'played' : 'suppressed_muted',
      });

      if (_speakReplies) {
        // Fire and forget — the bubble is already on screen.
        unawaited(_speak(_messages.length - 1, replyText));
      }

      if (!reply.isCorrect) {
        await _progressSyncService.recordCorrections(1);
      }
      _sessionStartedAt ??= DateTime.now();
    } catch (error) {
      if (charged) {
        await _homeViewModel.addHearts(1);
        charged = false;
      }
      _error = error is TimeoutException ? 'timeout' : error.toString();
      // The AI round trip here is a single try/catch, so every failure —
      // network, backend, or parsing — is reported under the same stage.
      // Distinguishing request_dispatch/model_response/response_render would
      // need separate try blocks around each step, which is a larger change
      // than this instrumentation pass.
      AnalyticsService.instance.log(AnalyticsEvents.aiChatResponseFailed, {
        AnalyticsParams.conversationId: conversationId,
        AnalyticsParams.messageSequence: sequence,
        AnalyticsParams.communicationMode: communicationMode,
        AnalyticsParams.failureStage: 'model_response',
        AnalyticsParams.errorType: error.runtimeType.toString(),
        AnalyticsParams.errorCode: 'tutor_chat_request_failed',
        AnalyticsParams.heartCharged: charged,
      });
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  /// Fires `ai_chat_exited` once per session (guarded), from whichever exit
  /// path notices first — the appbar back button, a system back gesture, or
  /// (as a fallback) the screen simply being disposed.
  void logExit(String exitMethod) {
    if (_loggedExit) return;
    _loggedExit = true;
    AnalyticsService.instance.log(AnalyticsEvents.aiChatExited, {
      AnalyticsParams.conversationId: conversationId,
      AnalyticsParams.exitMethod: exitMethod,
      AnalyticsParams.messageCount: _messages.length,
      AnalyticsParams.lastMode: _communicationModeValue,
      AnalyticsParams.heartBalanceAfter: _homeViewModel.lives,
    });
  }

  @override
  void dispose() {
    logExit('screen_closed');
    final startedAt = _sessionStartedAt;
    if (startedAt != null) {
      // Round to the nearest minute rather than truncating, and credit at
      // least 1 so a short-but-real exchange isn't recorded as 0 — closer
      // to how it actually felt than a flat per-open amount.
      final elapsedMinutes =
          (DateTime.now().difference(startedAt).inSeconds / 60).round();
      unawaited(_homeViewModel.recordChatMinutes(elapsedMinutes.clamp(1, 999)));
    }
    _connectivitySub?.cancel();
    _speechService.cancelListening();
    _tts.stop();
    _recorder.dispose();
    _deleteRecording(_recordPath);
    super.dispose();
  }
}
