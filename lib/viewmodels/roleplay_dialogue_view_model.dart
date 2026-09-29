import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/l10n/roleplay_scenario_l10n.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/newly_unlocked_content.dart';
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
  String get cefrLevel => _cefrLevel;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  LearningPathData get pathData => LearningPathData(
        title: _pathTitle,
        subtitle: _l10n.learnPathEarnXp(
          totalLessonsCount,
          totalLessonsCount * RoleplayXpRewards.dialogue,
        ),
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
    _pathTitle = _l10n.roleplayTrackTitle(
      RoleplayScenarioL10n.detailTitle(_l10n, _scenarioId),
      _l10n.dialogue,
    );
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

    final entryAction = switch (lesson.status) {
      LearningLessonStatus.completed => 'review',
      LearningLessonStatus.inProgress => 'resume',
      _ => 'start',
    };

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RoleplayDialogueLessonScreen(
          lesson: lesson,
          initialPhaseIndex: startIndex,
          onLessonCompleted: _markLessonCompleted,
          onProgressChanged: (index) => _saveInProgress(lesson, index),
          scenarioId: _scenarioId,
          cefrLevel: _cefrLevel,
          entryAction: entryAction,
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

  Future<List<String>> _markLessonCompleted(
    RoleplayDialogueLessonModel completedLesson,
    String lessonAttemptId,
  ) async {
    await _progressRepository.initialize();
    final existing =
        await _progressRepository.getProgress(completedLesson.lessonId);
    if (existing?.status == LearningLessonStatus.completed) {
      _syncService.lastCompletionXpGranted = 0;
      _syncService.lastModuleCompletionBonusXp = 0;
      _syncService.rememberNextLesson(
        nextLessonId: null,
        nextLessonNumber: null,
        nextWasLocked: false,
        alreadyCompleted: true,
      );
      await _loadLessons();
      return [];
    }

    final orderedIds = _lessons.map((l) => l.lessonId).toList();
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );
    // Snapshot the next lesson's pre-completion status (before this
    // completion may unlock it) to tell `unlocked` from `already_unlocked`.
    final nextLessonPriorStatus = nextId == null
        ? null
        : _lessons
            .firstWhere(
              (l) => l.lessonId == nextId,
              orElse: () => completedLesson,
            )
            .status;
    final nextLessonState = nextId == null
        ? 'module_completed'
        : nextLessonPriorStatus == LearningLessonStatus.locked
            ? 'unlocked'
            : 'already_unlocked';

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
      progressCefrLevel: _cefrLevel,
      progressRepository: _progressRepository,
      nextUnlockLessonId: nextId,
    );

    final xpBefore = _syncService.totalXp;
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

    _syncService.rememberNextLesson(
      nextLessonId: nextId,
      nextLessonNumber: nextId == null
          ? null
          : _lessons
              .where((lesson) => lesson.lessonId == nextId)
              .map((lesson) => lesson.number)
              .firstOrNull,
      nextWasLocked: nextLessonPriorStatus == LearningLessonStatus.locked,
      alreadyCompleted: false,
    );

    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonCompleted, {
      AnalyticsParams.lessonAttemptId: lessonAttemptId,
      AnalyticsParams.scenarioId: _scenarioId,
      AnalyticsParams.cefrLevel: _cefrLevel,
      AnalyticsParams.moduleType: 'dialogue',
      AnalyticsParams.lessonId: completedLesson.lessonId,
      AnalyticsParams.lessonNumber: completedLesson.number,
      AnalyticsParams.baseXpEarned: RoleplayXpRewards.dialogue,
      AnalyticsParams.nextLessonState: nextLessonState,
    });

    unawaited(_loadLessons());
    return NewlyUnlockedContent.compute(
      l10n: _l10n,
      xpBefore: xpBefore,
      xpAfter: _syncService.totalXp,
    );
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(_onLocaleChanged);
    super.dispose();
  }
}
