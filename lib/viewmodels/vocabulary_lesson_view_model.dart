import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_complete_screen.dart';

class VocabularyLessonViewModel extends ChangeNotifier {
  VocabularyLessonViewModel({
    required this.lesson,
    required this.initialWordIndex,
    required this.onLessonCompleted,
  }) : _currentWordIndex = initialWordIndex;

  final VocabularyLessonModel lesson;
  final int initialWordIndex;
  final ValueChanged<VocabularyLessonModel> onLessonCompleted;

  int _currentWordIndex;
  final Set<String> _savedWords = {};

  int get currentWordIndex => _currentWordIndex;
  int get totalWords => lesson.words.length;
  VocabularyWordModel get currentWord => lesson.words[_currentWordIndex];

  double get lessonProgress => (_currentWordIndex + 1) / totalWords;

  int get lessonProgressPercent => (lessonProgress * 100).round();

  bool get isFirstWord => _currentWordIndex == 0;
  bool get isLastWord => _currentWordIndex >= totalWords - 1;

  bool isWordSaved(String word) => _savedWords.contains(word);

  void listenWord(BuildContext context) {
    SnackbarHelper.showSuccess(context, 'Playing "${currentWord.word}"...');
  }

  void toggleSaveWord(BuildContext context) {
    if (_savedWords.contains(currentWord.word)) {
      _savedWords.remove(currentWord.word);
      SnackbarHelper.showSuccess(context, 'Removed from saved words');
    } else {
      _savedWords.add(currentWord.word);
      SnackbarHelper.showSuccess(context, 'Word saved!');
    }
    notifyListeners();
  }

  void previousWord() {
    if (isFirstWord) return;
    _currentWordIndex--;
    notifyListeners();
  }

  void nextWord(BuildContext context) {
    if (isLastWord) {
      onLessonCompleted(lesson);
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => VocabularyLessonCompleteScreen(
            lessonNumber: lesson.number,
            learnedWords: lesson.words.map((w) => w.word).toList(),
          ),
        ),
      );
      return;
    }
    _currentWordIndex++;
    notifyListeners();
  }
}
