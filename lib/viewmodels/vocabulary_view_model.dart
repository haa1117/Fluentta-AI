import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/lesson_type.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/entitlements/user_entitlements.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/srs_record.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_word_entry.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/daily_vocabulary_repository.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/spaced_repetition_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_screen.dart';

class VocabularyViewModel extends ChangeNotifier {
  VocabularyViewModel(
    this._localStorage,
    this._localeViewModel,
    this._contentRepository,
    this._progressRepository,
    this._syncService,
    this._dailyRepository,
    this._srsRepository,
    this._dailyLessonRepository,
  ) {
    _localeViewModel.addListener(_onLocaleChanged);
    _loadLessons();
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;
  final LessonContentRepository _contentRepository;
  final ProgressRepository _progressRepository;
  final ProgressSyncService _syncService;
  final DailyVocabularyRepository _dailyRepository;
  final SpacedRepetitionRepository _srsRepository;
  final DailyLessonRepository _dailyLessonRepository;

  List<VocabularyLessonModel> _lessons = [];
  Set<String> _todaysWordIds = {};
  Set<String> _dueWordIds = {};
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<VocabularyLessonModel> get lessons => _lessons;
  bool get isLoading => _isLoading;

  CefrLevel get level => UserEntitlements.learnBrowseLevel(_localStorage);

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  int get pathProgressPercent => (pathProgress * 100).round();

  LearningPathData get pathData => LearningPathData(
        title: _l10n.vocabularyPathTitle(levelCode),
        subtitle: _l10n.learnPathEarnXp(
          totalLessonsCount,
          totalLessonsCount * LessonXpRewards.vocabularyLesson,
        ),
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  String get levelCode => CefrLevelProgress.levelCodeLabel(_l10n, level);

  Set<String> get todaysWordIds => _todaysWordIds;
  Set<String> get dueWordIds => _dueWordIds;

  Future<void> reload() => _loadLessons();

  Future<void> _loadLessons() async {
    _isLoading = true;
    notifyListeners();

    await _contentRepository.initialize();
    await _progressRepository.initialize();
    await _srsRepository.initialize();
    await _dailyLessonRepository.initialize();

    await _dailyLessonRepository.prepareForDay(
      type: LessonType.vocabulary,
      cefrLevel: level.code,
      progressRepository: _progressRepository,
    );

    var lessons = await _contentRepository.getVocabularyLessons(
      level,
      progress: _progressRepository.allProgress,
    );
    final dailyState =
        _dailyLessonRepository.stateFor(LessonType.vocabulary, level.code);
    _lessons =
        _dailyLessonRepository.applyVocabularyDailyGate(lessons, dailyState);

    final todaysWords = await _dailyRepository.getTodaysWords(level);
    _todaysWordIds = todaysWords.map((w) => w.id).toSet();

    final dueReviews = await _srsRepository.getDueReviews();
    _dueWordIds = dueReviews.map((r) => r.wordId).toSet();

    _isLoading = false;
    notifyListeners();
  }

  void _onLocaleChanged() {
    _loadLessons();
  }

  /// Picks the best starting word index: due review first, then today's word.
  int _resolveStartIndex(VocabularyLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.inProgress) {
      final saved = lesson.wordsCompleted.clamp(0, lesson.words.length - 1);
      for (var i = saved; i < lesson.words.length; i++) {
        final id = _wordId(lesson, lesson.words[i].word);
        if (_dueWordIds.contains(id) || _todaysWordIds.contains(id)) {
          return i;
        }
      }
      return saved;
    }

    for (var i = 0; i < lesson.words.length; i++) {
      final id = _wordId(lesson, lesson.words[i].word);
      if (_dueWordIds.contains(id)) return i;
    }
    for (var i = 0; i < lesson.words.length; i++) {
      final id = _wordId(lesson, lesson.words[i].word);
      if (_todaysWordIds.contains(id)) return i;
    }
    return 0;
  }

  String _wordId(VocabularyLessonModel lesson, String word) {
    return VocabularyWordEntry.buildId(lesson.lessonId, word);
  }

  Future<void> onWordStudied({
    required String lessonId,
    required String word,
  }) async {
    final wordId = VocabularyWordEntry.buildId(lessonId, word);
    final existing = await _srsRepository.getRecord(wordId);

    if (existing != null && existing.isDueOn(DateTime.now())) {
      await _srsRepository.recordReview(wordId, SrsRating.good);
    } else {
      await _srsRepository.introduceWord(wordId);
    }

    if (_todaysWordIds.contains(wordId)) {
      await _dailyRepository.recordWordStudied(wordId);
    }

    _dueWordIds = (await _srsRepository.getDueReviews())
        .map((r) => r.wordId)
        .toSet();
    notifyListeners();
  }

  Future<void> openLesson(
    BuildContext context,
    VocabularyLessonModel lesson,
  ) async {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.words.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    if (lesson.status == LearningLessonStatus.notStarted) {
      await _dailyLessonRepository.recordLessonStarted(
        type: LessonType.vocabulary,
        cefrLevel: level.code,
        lessonId: lesson.lessonId,
      );
    }
    if (!context.mounted) return;

    final startIndex = _resolveStartIndex(lesson);

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => VocabularyLessonScreen(
          lesson: lesson,
          initialWordIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
          onWordStudied: (word) => onWordStudied(
            lessonId: lesson.lessonId,
            word: word,
          ),
          cefrLevel: level.code,
          completionXpEarned: LessonXpRewards.vocabularyLesson,
        ),
      ),
    );
  }

  Future<void> _saveInProgress(VocabularyLessonModel lesson, int index) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: LessonType.vocabulary.id,
      cefrLevel: level.code,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: LessonType.vocabulary.id,
        cefrLevel: level.code,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<void> _markLessonCompleted(VocabularyLessonModel completedLesson) async {
    final orderedIds = await _contentRepository.orderedLessonIds(
      level,
      LessonType.vocabulary,
    );
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: LessonType.vocabulary.id,
      cefrLevel: level.code,
      finalIndex: completedLesson.totalWords,
    );

    await _dailyLessonRepository.recordLessonCompleted(
      type: LessonType.vocabulary,
      cefrLevel: level.code,
      completedLessonId: completedLesson.lessonId,
      nextUnlockLessonId: nextId,
    );

    await _syncService.onLessonCompleted(
      progress: LessonProgressModel(
        lessonId: completedLesson.lessonId,
        type: LessonType.vocabulary.id,
        cefrLevel: level.code,
        status: LearningLessonStatus.completed,
        currentIndex: completedLesson.totalWords,
        updatedAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
      wordsLearned: completedLesson.totalWords,
    );

    await _loadLessons();
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(_onLocaleChanged);
    super.dispose();
  }
}
