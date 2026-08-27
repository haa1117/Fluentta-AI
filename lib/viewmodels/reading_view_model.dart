import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/lesson_type.dart';
import 'package:fluentta_ai/core/entitlements/user_entitlements.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/lesson_content_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/reading/reading_lesson_screen.dart';

class ReadingViewModel extends ChangeNotifier {
  ReadingViewModel(
    this._localStorage,
    this._localeViewModel,
    this._contentRepository,
    this._progressRepository,
    this._syncService,
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
  final DailyLessonRepository _dailyLessonRepository;

  List<ReadingLessonModel> _lessons = [];
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<ReadingLessonModel> get lessons => _lessons;
  bool get isLoading => _isLoading;

  CefrLevel get _level => UserEntitlements.contentLevelForUser(
        _localStorage.englishLevel,
        _localStorage.isPremium,
      );

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  double get pathProgress =>
      totalLessonsCount == 0 ? 0 : completedLessonsCount / totalLessonsCount;

  LearningPathData get pathData => LearningPathData(
        title: _l10n.readingPathTitle(levelCode),
        subtitle: _l10n.readingPathSub,
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
    await _dailyLessonRepository.initialize();

    await _dailyLessonRepository.prepareForDay(
      type: LessonType.reading,
      cefrLevel: _level.code,
      progressRepository: _progressRepository,
    );

    var lessons = await _contentRepository.getReadingLessons(
      _level,
      progress: _progressRepository.allProgress,
    );
    final dailyState =
        _dailyLessonRepository.stateFor(LessonType.reading, _level.code);
    _lessons =
        _dailyLessonRepository.applyReadingDailyGate(lessons, dailyState);
    _isLoading = false;
    notifyListeners();
  }

  void _onLocaleChanged() {
    _loadLessons();
  }

  Future<void> openLesson(BuildContext context, ReadingLessonModel lesson) async {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.phases.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    if (lesson.status == LearningLessonStatus.notStarted) {
      await _dailyLessonRepository.recordLessonStarted(
        type: LessonType.reading,
        cefrLevel: _level.code,
        lessonId: lesson.lessonId,
      );
    }
    if (!context.mounted) return;

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.phasesCompleted.clamp(0, lesson.phases.length - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ReadingLessonScreen(
          lesson: lesson,
          initialPhaseIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
        ),
      ),
    );
  }

  Future<void> _saveInProgress(ReadingLessonModel lesson, int index) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: LessonType.reading.id,
      cefrLevel: _level.code,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: LessonType.reading.id,
        cefrLevel: _level.code,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<void> _markLessonCompleted(ReadingLessonModel completedLesson) async {
    final orderedIds = await _contentRepository.orderedLessonIds(
      _level,
      LessonType.reading,
    );
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: LessonType.reading.id,
      cefrLevel: _level.code,
      finalIndex: completedLesson.totalPhases,
    );

    await _dailyLessonRepository.recordLessonCompleted(
      type: LessonType.reading,
      cefrLevel: _level.code,
      completedLessonId: completedLesson.lessonId,
      nextUnlockLessonId: nextId,
    );

    await _syncService.onLessonCompleted(
      progress: LessonProgressModel(
        lessonId: completedLesson.lessonId,
        type: LessonType.reading.id,
        cefrLevel: _level.code,
        status: LearningLessonStatus.completed,
        currentIndex: completedLesson.totalPhases,
        updatedAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
    );

    await _loadLessons();
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(_onLocaleChanged);
    super.dispose();
  }
}
