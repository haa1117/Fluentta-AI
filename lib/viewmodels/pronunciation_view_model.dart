import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/pronunciation_phrase_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';

class PronunciationViewModel extends ChangeNotifier {
  PronunciationViewModel(this._homeViewModel);

  final HomeViewModel _homeViewModel;

  int _currentPhraseIndex = 0;
  final List<int> _completedScores = [];
  bool _heartDeducted = false;

  int get lives => _homeViewModel.lives;
  int get currentPhraseIndex => _currentPhraseIndex;
  int get totalPhrases => PronunciationContent.phrases.length;
  bool get isLastPhrase => _currentPhraseIndex >= totalPhrases - 1;

  PronunciationPhraseData get currentPhrase =>
      PronunciationContent.phrases[_currentPhraseIndex];

  int get averageScore {
    if (_completedScores.isEmpty) return 0;
    final sum = _completedScores.reduce((a, b) => a + b);
    return (sum / _completedScores.length).round();
  }

  String get bestWord {
    var best = '';
    var bestScore = 0;
    final completedCount = _completedScores.length;
    for (var i = 0; i < completedCount; i++) {
      for (final word in PronunciationContent.phrases[i].words) {
        if (word.confidence > bestScore) {
          bestScore = word.confidence;
          best = word.word;
        }
      }
    }
    if (best.isNotEmpty) return best;
    return currentPhrase.words.first.word;
  }

  Future<bool> deductHeartIfNeeded() async {
    if (_heartDeducted) return true;
    final ok = await _homeViewModel.useHeart();
    if (ok) {
      _heartDeducted = true;
      notifyListeners();
    }
    return ok;
  }

  void completeCurrentPhrase() {
    _completedScores.add(currentPhrase.overallScore);
    notifyListeners();
  }

  void nextPhrase() {
    if (!isLastPhrase) {
      _currentPhraseIndex++;
      _heartDeducted = false;
      notifyListeners();
    }
  }

  void resetSession() {
    _currentPhraseIndex = 0;
    _completedScores.clear();
    _heartDeducted = false;
    notifyListeners();
  }
}
