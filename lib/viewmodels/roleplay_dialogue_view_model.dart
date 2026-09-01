import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/ai_tutor/roleplay_dialogue_lesson_screen.dart';

class RoleplayDialogueViewModel extends ChangeNotifier {
  RoleplayDialogueViewModel(
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

  List<RoleplayDialogueLessonModel> _lessons = [];
  String _pathTitle = '';
  String _pathSubtitle = '';
  String _cefrLevel = 'A1';
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<RoleplayDialogueLessonModel> get lessons => _lessons;
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

    final vocabPath = await _contentRepository.getVocabularyPath(_scenarioId);
    _pathTitle = '${vocabPath.pathTitle.split(' ').first} Dialogue';
    _pathSubtitle = vocabPath.pathSubtitle;
    _cefrLevel = vocabPath.cefrLevel;

    await _dailyLessonRepository.prepareForDayPath(
      typeId: RoleplayPracticeType.dialogue.id,
      scopeId: _scenarioId,
      progressCefrLevel: _cefrLevel,
      progressRepository: _progressRepository,
    );

    var lessons = await _contentRepository.buildDialogueLessons(
      scenarioId: _scenarioId,
      progressRepository: _progressRepository,
    );

    final dailyState = _dailyLessonRepository.stateForPath(
      RoleplayPracticeType.dialogue.id,
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
    RoleplayDialogueLessonModel lesson,
  ) async {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.phases.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    if (lesson.status == LearningLessonStatus.notStarted) {
      await _dailyLessonRepository.recordLessonStartedPath(
        typeId: RoleplayPracticeType.dialogue.id,
        scopeId: _scenarioId,
        lessonId: lesson.lessonId,
      );
    }
    if (!context.mounted) return;

    final startIndex = lesson.status == LearningLessonStatus.inProgress
        ? lesson.phasesCompleted.clamp(0, lesson.totalPhases - 1)
        : 0;

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RoleplayDialogueLessonScreen(
          lesson: lesson,
          initialPhaseIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
        ),
      ),
    );
  }

  Future<void> _saveInProgress(
    RoleplayDialogueLessonModel lesson,
    int index,
  ) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: RoleplayPracticeType.dialogue.id,
      cefrLevel: _cefrLevel,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: RoleplayPracticeType.dialogue.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<void> _markLessonCompleted(
    RoleplayDialogueLessonModel completedLesson,
  ) async {
    await _progressRepository.initialize();
    final existing =
        await _progressRepository.getProgress(completedLesson.lessonId);
    if (existing?.status == LearningLessonStatus.completed) {
      await _loadLessons();
      return;
    }

    final orderedIds = _lessons.map((l) => l.lessonId).toList();
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: RoleplayPracticeType.dialogue.id,
      cefrLevel: _cefrLevel,
      finalIndex: completedLesson.totalPhases,
    );

    await _dailyLessonRepository.recordLessonCompletedPath(
      typeId: RoleplayPracticeType.dialogue.id,
      scopeId: _scenarioId,
      completedLessonId: completedLesson.lessonId,
      nextUnlockLessonId: nextId,
    );

    await _syncService.onRoleplayModuleCompleted(
      progress: LessonProgressModel(
        lessonId: completedLesson.lessonId,
        type: RoleplayPracticeType.dialogue.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.completed,
        currentIndex: completedLesson.totalPhases,
        updatedAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
      xpAmount: RoleplayXpRewards.dialogue,
      scenarioId: _scenarioId,
      lessonNumber: completedLesson.number,
    );

    await _loadLessons();
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(_onLocaleChanged);
    super.dispose();
  }
}
