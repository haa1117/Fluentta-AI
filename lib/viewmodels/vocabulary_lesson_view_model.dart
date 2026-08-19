import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_complete_screen.dart';

class VocabularyLessonViewModel extends ChangeNotifier {
  VocabularyLessonViewModel({
    required this.lesson,
    required this.initialWordIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    this.onProgressChanged,
  }) : _currentWordIndex = initialWordIndex;

  final VocabularyLessonModel lesson;
  final int initialWordIndex;
  final ValueChanged<VocabularyLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final TextToSpeechService textToSpeechService;

  int _currentWordIndex;
  final Set<String> _savedWords = {};
  bool _isListening = false;

  int get currentWordIndex => _currentWordIndex;
  int get totalWords => lesson.words.length;
  VocabularyWordModel get currentWord => lesson.words[_currentWordIndex];
  bool get isListening => _isListening;

  double get lessonProgress => (_currentWordIndex + 1) / totalWords;

  int get lessonProgressPercent => (lessonProgress * 100).round();

  bool get isFirstWord => _currentWordIndex == 0;
  bool get isLastWord => _currentWordIndex >= totalWords - 1;

  bool isWordSaved(String word) => _savedWords.contains(word);

  Future<void> listenWord(BuildContext context) async {
    if (_isListening) {
      await textToSpeechService.stop();
      _isListening = false;
      notifyListeners();
      return;
    }

    final l10n = context.l10n;
    _isListening = true;
    notifyListeners();

    final didSpeak = await textToSpeechService.speak(
      currentWord.word,
      onComplete: () {
        _isListening = false;
        notifyListeners();
      },
    );

    if (!didSpeak) {
      _isListening = false;
      notifyListeners();
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, l10n.listenUnavailable);
      }
      return;
    }

    if (context.mounted) {
      SnackbarHelper.showSuccess(context, l10n.playingWord(currentWord.word));
    }
  }

  void toggleSaveWord(BuildContext context) {
    final l10n = context.l10n;
    if (_savedWords.contains(currentWord.word)) {
      _savedWords.remove(currentWord.word);
      SnackbarHelper.showSuccess(context, l10n.wordRemoved);
    } else {
      _savedWords.add(currentWord.word);
      SnackbarHelper.showSuccess(context, l10n.wordSaved);
    }
    notifyListeners();
  }

  void previousWord() {
    if (isFirstWord) return;
    textToSpeechService.stop();
    _isListening = false;
    _currentWordIndex--;
    onProgressChanged?.call(_currentWordIndex);
    notifyListeners();
  }

  void nextWord(BuildContext context) {
    textToSpeechService.stop();
    _isListening = false;

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
    onProgressChanged?.call(_currentWordIndex);
    notifyListeners();
  }

  @override
  void dispose() {
    textToSpeechService.stop();
    super.dispose();
  }
}
