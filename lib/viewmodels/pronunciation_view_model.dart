import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/pronunciation_phrase_model.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';

class PronunciationViewModel extends ChangeNotifier {
  PronunciationViewModel(
    this._homeViewModel,
    this._textToSpeechService,
    this._assessmentService,
    this._progressSyncService,
  );

  final HomeViewModel _homeViewModel;
  final TextToSpeechService _textToSpeechService;
  final PronunciationAssessmentService _assessmentService;
  final ProgressSyncService _progressSyncService;

  int _currentPhraseIndex = 0;
  final List<int> _completedScores = [];
  final List<PronunciationAssessmentResult> _phraseResults = [];
  PronunciationAssessmentResult? _currentResult;
  bool _isRecording = false;
  bool _isListeningPhrase = false;
  double _soundLevel = 0;

  int get lives => _homeViewModel.lives;
  int get currentPhraseIndex => _currentPhraseIndex;
  int get totalPhrases => PronunciationContent.phrases.length;
  bool get isLastPhrase => _currentPhraseIndex >= totalPhrases - 1;
  bool get isRecording => _isRecording || _assessmentService.isListening;
  bool get isListeningPhrase => _isListeningPhrase;
  double get soundLevel => _soundLevel;
  bool get canAffordCheck => lives > 0;

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

  /// Deducts one heart for each pronunciation check (free tier).
  Future<bool> deductHeartForCheck() async {
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
      _assessmentService.lastStartFailure;

  Future<bool> startRecording() async {
    _currentResult = null;
    _soundLevel = 0;
    _isRecording = true;
    notifyListeners();

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

  Future<PronunciationAssessmentResult?> stopRecordingAndAssess() async {
    _isRecording = false;
    notifyListeners();

    final spokenText = await _assessmentService.stopListening();
    final result = _assessmentService.assess(
      expectedPhrase: currentPhraseText,
      spokenText: spokenText,
    );
    _currentResult = result;

    await _progressSyncService.recordCorrections(result.correctionCount);

    notifyListeners();
    return result;
  }

  void cancelRecording() {
    _assessmentService.cancelListening();
    _isRecording = false;
    _soundLevel = 0;
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
    _assessmentService.cancelListening();
    notifyListeners();
  }

  @override
  void dispose() {
    _assessmentService.cancelListening();
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
