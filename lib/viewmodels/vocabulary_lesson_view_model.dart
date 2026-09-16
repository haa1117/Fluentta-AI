import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_completion_nav.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
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
    this.completionXpEarned = LessonXpRewards.vocabularyLesson,
  }) : _currentWordIndex = initialWordIndex {
    _loadSavedWords();
  }

  final VocabularyLessonModel lesson;
  final int initialWordIndex;
  final Future<List<String>> Function(VocabularyLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final Future<void> Function(String word)? onWordStudied;
  final TextToSpeechService textToSpeechService;
  final SavedWordsRepository savedWordsRepository;
  final String cefrLevel;
  final int completionXpEarned;

  int _currentWordIndex;
  final Set<String> _savedWordIds = {};
  bool _isListening = false;
  bool _isCompleting = false;

  /// True once the final word's continue has been tapped and the completion
  /// write is in flight — guards against rapid extra taps queuing up
  /// multiple pushes of the completion screen.
  bool get isCompleting => _isCompleting;

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
      if (_isCompleting) return;
      _isCompleting = true;
      notifyListeners();
      await completeLessonAndNavigate(
        context: context,
        complete: () => onLessonCompleted(lesson),
        buildScreen: (unlocked) => VocabularyLessonCompleteScreen(
          lessonNumber: lesson.number,
          lessonId: lesson.lessonId,
          xpEarned: completionXpEarned,
          learnedWords: lesson.words.map((w) => w.word).toList(),
          newlyUnlocked: unlocked,
        ),
        onFailed: () {
          _isCompleting = false;
          notifyListeners();
        },
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
