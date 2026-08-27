import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_quick_check_lesson_screen.dart';
import 'package:provider/provider.dart';

class RoleplayQuickCheckViewModel extends ChangeNotifier {
  RoleplayQuickCheckViewModel(
    this._scenarioId,
    this._localeViewModel,
    this._contentRepository,
    this._progressRepository,
    this._syncService,
    this._dailyLessonRepository,
  ) {
    _localeViewModel.addListener(_onLocaleChanged);
    _loadLessons();
  }

  final String _scenarioId;
  final LocaleViewModel _localeViewModel;
  final RoleplayContentRepository _contentRepository;
  final ProgressRepository _progressRepository;
  final ProgressSyncService _syncService;
  final DailyLessonRepository _dailyLessonRepository;

  List<RoleplayQuickCheckLessonModel> _lessons = [];
  String _pathTitle = '';
  String _pathSubtitle = '';
  String _cefrLevel = 'A1';
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<RoleplayQuickCheckLessonModel> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String get pathTitle => _pathTitle;
  String get pathSubtitle => _pathSubtitle;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  LearningPathData get pathData => LearningPathData(
        title: _pathTitle,
        subtitle: _pathSubtitle,
        completedLessons: completedLessonsCount,
        totalLessons: totalLessonsCount,
      );

  Future<void> reload() => _loadLessons();

  Future<void> _loadLessons() async {
    _isLoading = true;
    notifyListeners();

    await _contentRepository.initialize();
    await _progressRepository.initialize();
    await _dailyLessonRepository.initialize();

    final path = await _contentRepository.getQuickCheckPath(_scenarioId);
    _pathTitle = path.pathTitle;
    _pathSubtitle = path.pathSubtitle;
    _cefrLevel = path.cefrLevel;

    await _dailyLessonRepository.prepareForDayPath(
      typeId: RoleplayPracticeType.quickCheck.id,
      scopeId: _scenarioId,
      progressCefrLevel: _cefrLevel,
      progressRepository: _progressRepository,
    );

    var lessons = await _contentRepository.buildQuickCheckLessons(
      scenarioId: _scenarioId,
      progressRepository: _progressRepository,
    );

    final dailyState = _dailyLessonRepository.stateForPath(
      RoleplayPracticeType.quickCheck.id,
      _scenarioId,
    );
    _lessons = _dailyLessonRepository.applyGenericDailyGate(
      lessons,
      dailyState,
      lessonIdOf: (lesson) => lesson.lessonId,
      statusOf: (lesson) => lesson.status,
      withStatus: (lesson, status) => lesson.copyWith(status: status),
    );

    _isLoading = false;
    notifyListeners();
  }

  void _onLocaleChanged() => _loadLessons();

  Future<void> openLesson(
    BuildContext context,
    RoleplayQuickCheckLessonModel lesson,
  ) async {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.questions.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    if (lesson.status == LearningLessonStatus.notStarted) {
      await _dailyLessonRepository.recordLessonStartedPath(
        typeId: RoleplayPracticeType.quickCheck.id,
        scopeId: _scenarioId,
        lessonId: lesson.lessonId,
      );
    }
    if (!context.mounted) return;

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.questionsCompleted.clamp(0, lesson.questions.length - 1)
        : 0;

    final progressSyncService = context.read<ProgressSyncService>();

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RoleplayQuickCheckLessonScreen(
          lesson: lesson,
          initialQuestionIndex: startIndex,
          cefrLevel: _cefrLevel,
          progressSyncService: progressSyncService,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
        ),
      ),
    );
  }

  Future<void> _saveInProgress(
    RoleplayQuickCheckLessonModel lesson,
    int index,
  ) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: RoleplayPracticeType.quickCheck.id,
      cefrLevel: _cefrLevel,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: RoleplayPracticeType.quickCheck.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<void> _markLessonCompleted(
    RoleplayQuickCheckLessonModel completedLesson,
  ) async {
    final orderedIds = _lessons.map((l) => l.lessonId).toList();
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: RoleplayPracticeType.quickCheck.id,
      cefrLevel: _cefrLevel,
      finalIndex: completedLesson.totalQuestions,
    );

    await _dailyLessonRepository.recordLessonCompletedPath(
      typeId: RoleplayPracticeType.quickCheck.id,
      scopeId: _scenarioId,
      completedLessonId: completedLesson.lessonId,
      nextUnlockLessonId: nextId,
    );

    await _syncService.onLessonCompleted(
      progress: LessonProgressModel(
        lessonId: completedLesson.lessonId,
        type: RoleplayPracticeType.quickCheck.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.completed,
        currentIndex: completedLesson.totalQuestions,
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
