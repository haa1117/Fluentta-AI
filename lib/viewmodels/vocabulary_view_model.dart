import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/lesson_type.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
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
  ) {
    _localeViewModel.addListener(_onLocaleChanged);
    _loadLessons();
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;
  final LessonContentRepository _contentRepository;
  final ProgressRepository _progressRepository;
  final ProgressSyncService _syncService;

  List<VocabularyLessonModel> _lessons = [];
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<VocabularyLessonModel> get lessons => _lessons;
  bool get isLoading => _isLoading;

  CefrLevel get _level => CefrLevel.fromSetupId(_localStorage.englishLevel);

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  int get pathProgressPercent => (pathProgress * 100).round();

  LearningPathData get pathData => LearningPathData(
        title: _l10n.vocabularyPathTitle(levelCode),
        subtitle: _l10n.vocabularyPathSub,
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  String get levelCode =>
      LocalizedContent.levelCode(_l10n, _localStorage.englishLevel);

  Future<void> reload() => _loadLessons();

  Future<void> _loadLessons() async {
    _isLoading = true;
    notifyListeners();
    await _contentRepository.initialize();
    await _progressRepository.initialize();
    _lessons = await _contentRepository.getVocabularyLessons(
      _level,
      progress: _progressRepository.allProgress,
    );
    _isLoading = false;
    notifyListeners();
  }

  void _onLocaleChanged() {
    _loadLessons();
  }

  void openLesson(BuildContext context, VocabularyLessonModel lesson) {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.words.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.wordsCompleted.clamp(0, lesson.words.length - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => VocabularyLessonScreen(
          lesson: lesson,
          initialWordIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
        ),
      ),
    );
  }

  Future<void> _saveInProgress(VocabularyLessonModel lesson, int index) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: LessonType.vocabulary.id,
      cefrLevel: _level.code,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: LessonType.vocabulary.id,
        cefrLevel: _level.code,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<void> _markLessonCompleted(VocabularyLessonModel completedLesson) async {
    final orderedIds = await _contentRepository.orderedLessonIds(
      _level,
      LessonType.vocabulary,
    );
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: LessonType.vocabulary.id,
      cefrLevel: _level.code,
      finalIndex: completedLesson.totalWords,
      unlockLessonId: nextId,
    );

    await _syncService.onLessonCompleted(
      progress: LessonProgressModel(
        lessonId: completedLesson.lessonId,
        type: LessonType.vocabulary.id,
        cefrLevel: _level.code,
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
