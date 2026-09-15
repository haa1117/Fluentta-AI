import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
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
    Connectivity? connectivity,
  })  : _homeViewModel = homeViewModel,
        _aiBackendService = aiBackendService,
        _speechService = speechService,
        _progressSyncService = progressSyncService,
        _tts = textToSpeechService,
        _localStorage = localStorage,
        _cefrLevel = cefrLevel,
        _goal = goal,
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
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  final List<OpenChatMessage> _messages = [];
  ChatInputMode _inputMode = ChatInputMode.text;
  VoiceCaptureState _voiceState = VoiceCaptureState.idle;
  bool _isSending = false;
  bool _isTranscribing = false;
  bool _speakReplies = true;
  bool _isOnline = true;
  int? _speakingIndex;
  String? _error;

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

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  void setInputMode(ChatInputMode mode) {
    if (_inputMode == mode) return;
    _inputMode = mode;
    if (mode == ChatInputMode.text && _voiceState != VoiceCaptureState.idle) {
      unawaited(cancelVoiceCapture());
    }
    notifyListeners();
  }

  // --- Speech output (tutor reads its replies aloud) ----------------------

  Future<void> toggleSpeakReplies() async {
    _speakReplies = !_speakReplies;
    notifyListeners();
    await _localStorage.setChatSpeakRepliesEnabled(_speakReplies);
    if (!_speakReplies) {
      await _stopSpeaking();
    }
  }

  /// Play, or stop if it is already playing, the bubble at [index].
  Future<void> speakMessage(int index) async {
    if (index < 0 || index >= _messages.length) return;
    if (_speakingIndex == index) {
      await _stopSpeaking();
      return;
    }
    await _speak(index, _messages[index].text);
  }

  Future<void> _speak(int index, String text) async {
    if (text.trim().isEmpty) return;
    _speakingIndex = index;
    notifyListeners();
    await _tts.speak(
      text,
      onComplete: () {
        if (_speakingIndex == index) {
          _speakingIndex = null;
          notifyListeners();
        }
      },
    );
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
    await _sendUserText(text);
  }

  // --- Voice capture -------------------------------------------------------

  Future<void> beginVoiceCapture() async {
    if (_isSending || _voiceState != VoiceCaptureState.idle) return;
    if (!await _ensureOnline()) return;
    // Don't let the tutor's voice bleed into the microphone.
    await _stopSpeaking();
    _sttFallbackActive = false;
    _recordPath = null;

    var started = false;
    try {
      if (await _recorder.hasPermission()) {
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

    if (!started) {
      // No recorder — use the on-device recognizer for this capture only.
      started = await _speechService.startListening();
      _sttFallbackActive = started;
    }

    if (started) {
      _voiceState = VoiceCaptureState.recording;
    } else {
      _voiceState = VoiceCaptureState.idle;
      _error = 'speech_unavailable';
    }
    notifyListeners();
  }

  void lockVoiceCapture() {
    if (_voiceState != VoiceCaptureState.recording) return;
    _voiceState = VoiceCaptureState.locked;
    notifyListeners();
  }

  Future<void> cancelVoiceCapture() async {
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
    notifyListeners();
  }

  Future<void> finishVoiceCapture() async {
    if (_voiceState == VoiceCaptureState.idle) return;
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
      await _sendUserText(text);
    } else {
      _error = 'speech_unavailable';
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

  /// Debug builds don't spend hearts, so the chat can be tested before the
  /// store products / subscriptions exist. Never true in a release build.
  bool get _heartsBypassed => kDebugMode || _homeViewModel.hasUnlimitedHearts;

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

  Future<void> _sendUserText(String text) async {
    if (!await _ensureOnline()) return;
    if (!_heartsBypassed && _homeViewModel.lives <= 0) {
      _error = 'out_of_hearts';
      notifyListeners();
      return;
    }

    await _stopSpeaking();
    _error = null;
    _isSending = true;
    _messages.add(OpenChatMessage(isUser: true, text: text));
    notifyListeners();

    var charged = false;
    if (!_heartsBypassed) {
      charged = await _homeViewModel.useHeart();
      if (!charged) {
        _isSending = false;
        _error = 'out_of_hearts';
        notifyListeners();
        return;
      }
    }

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
        ),
      );

      if (_speakReplies) {
        // Fire and forget — the bubble is already on screen.
        unawaited(_speak(_messages.length - 1, replyText));
      }

      if (!reply.isCorrect) {
        await _progressSyncService.recordCorrections(1);
      }
      if (_messages.where((message) => message.isUser).length == 1) {
        await _homeViewModel.startAiChat(() {});
      }
    } catch (error) {
      if (charged) {
        await _homeViewModel.addHearts(1);
      }
      _error = error.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    _speechService.cancelListening();
    _tts.stop();
    _recorder.dispose();
    _deleteRecording(_recordPath);
    super.dispose();
  }
}
