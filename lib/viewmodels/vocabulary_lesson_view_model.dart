import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/vocabulary_word_entry.dart';
import 'package:fluentta_ai/data/repositories/saved_words_repository.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_complete_screen.dart';

class VocabularyLessonViewModel extends ChangeNotifier {
  VocabularyLessonViewModel({
    required this.lesson,
    required this.initialWordIndex,
    required this.onLessonCompleted,
    required this.textToSpeechService,
    required this.savedWordsRepository,
    required this.cefrLevel,
    this.onProgressChanged,
    this.onWordStudied,
  }) : _currentWordIndex = initialWordIndex {
    _loadSavedWords();
  }

  final VocabularyLessonModel lesson;
  final int initialWordIndex;
  final ValueChanged<VocabularyLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final Future<void> Function(String word)? onWordStudied;
  final TextToSpeechService textToSpeechService;
  final SavedWordsRepository savedWordsRepository;
  final String cefrLevel;

  int _currentWordIndex;
  final Set<String> _savedWordIds = {};
  bool _isListening = false;

  int get currentWordIndex => _currentWordIndex;
  int get totalWords => lesson.words.length;
  VocabularyWordModel get currentWord => lesson.words[_currentWordIndex];
  bool get isListening => _isListening;

  double get lessonProgress => (_currentWordIndex + 1) / totalWords;

  int get lessonProgressPercent => (lessonProgress * 100).round();

  bool get isFirstWord => _currentWordIndex == 0;
  bool get isLastWord => _currentWordIndex >= totalWords - 1;

  bool isWordSaved(String word) => _savedWordIds.contains(
        VocabularyWordEntry.buildId(lesson.lessonId, word),
      );

  Future<void> _loadSavedWords() async {
    await savedWordsRepository.initialize();
    for (final word in lesson.words) {
      final id = VocabularyWordEntry.buildId(lesson.lessonId, word.word);
      if (await savedWordsRepository.isSaved(id)) {
        _savedWordIds.add(id);
      }
    }
    notifyListeners();
  }

  VocabularyWordEntry _entryFor(VocabularyWordModel wordModel) {
    return VocabularyWordEntry.fromWord(
      lessonId: lesson.lessonId,
      cefrLevel: cefrLevel,
      wordModel: wordModel,
    );
  }

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

  Future<void> toggleSaveWord(BuildContext context) async {
    final l10n = context.l10n;
    final entry = _entryFor(currentWord);
    final saved = await savedWordsRepository.toggle(entry);
    if (saved) {
      _savedWordIds.add(entry.id);
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, l10n.wordSaved);
      }
    } else {
      _savedWordIds.remove(entry.id);
      if (context.mounted) {
        SnackbarHelper.showSuccess(context, l10n.wordRemoved);
      }
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

  Future<void> nextWord(BuildContext context) async {
    textToSpeechService.stop();
    _isListening = false;

    final studiedWord = currentWord.word;
    await onWordStudied?.call(studiedWord);

    if (isLastWord) {
      onLessonCompleted(lesson);
      if (!context.mounted) return;
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
