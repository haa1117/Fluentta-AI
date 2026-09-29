import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/analytics/cefr_lesson_analytics.dart';
import 'package:fluentta_ai/core/cefr/lesson_unlock_logic.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/l10n/roleplay_scenario_l10n.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/newly_unlocked_content.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/views/vocabulary/vocabulary_lesson_screen.dart';

class RoleplayVocabularyViewModel extends ChangeNotifier {
  RoleplayVocabularyViewModel(
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

  List<VocabularyLessonModel> _lessons = [];
  String _pathTitle = '';
  String _pathSubtitle = '';
  String _cefrLevel = 'A1';
  bool _isLoading = true;

  AppLocalizations get _l10n => _localeViewModel.strings;

  List<VocabularyLessonModel> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String get pathTitle => _pathTitle;
  String get cefrLevel => _cefrLevel;
  String get scenarioId => _scenarioId;
  String get pathSubtitle => _pathSubtitle;

  int get completedLessonsCount =>
      _lessons.where((l) => l.status == LearningLessonStatus.completed).length;

  int get totalLessonsCount => _lessons.length;

  LearningPathData get pathData => LearningPathData(
        title: _pathTitle,
        subtitle: _l10n.learnPathEarnXp(
          totalLessonsCount,
          totalLessonsCount * RoleplayXpRewards.vocabulary,
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

    final path = await _contentRepository.getVocabularyPath(_scenarioId);
    _pathTitle = _l10n.roleplayTrackTitle(
      RoleplayScenarioL10n.detailTitle(_l10n, _scenarioId),
      _l10n.vocabulary,
    );
    _pathSubtitle = path.pathSubtitle;
    _cefrLevel = path.cefrLevel;

    await _dailyLessonRepository.prepareForDayPath(
      typeId: RoleplayPracticeType.vocabulary.id,
      scopeId: _scenarioId,
      progressCefrLevel: _cefrLevel,
      progressRepository: _progressRepository,
    );

    var lessons = await _contentRepository.buildVocabularyLessons(
      scenarioId: _scenarioId,
      progressRepository: _progressRepository,
    );

    final dailyState = _dailyLessonRepository.stateForPath(
      RoleplayPracticeType.vocabulary.id,
      _scenarioId,
    );
    _lessons =
        _dailyLessonRepository.applyVocabularyDailyGate(lessons, dailyState);

    _isLoading = false;
    notifyListeners();
  }

  void _onLocaleChanged() => _loadLessons();

  Future<void> openLesson(BuildContext context, VocabularyLessonModel lesson) async {
    if (lesson.status == LearningLessonStatus.locked) return;
    if (lesson.words.isEmpty) {
      SnackbarHelper.showSuccess(context, _l10n.lessonContentSoon);
      return;
    }

    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonClicked, {
      AnalyticsParams.scenarioId: _scenarioId,
      AnalyticsParams.cefrLevel: _cefrLevel.toLowerCase(),
      AnalyticsParams.moduleType: 'vocabulary',
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lessonNumber: lesson.number,
      AnalyticsParams.lessonState: lessonStateFor(lesson.status),
      AnalyticsParams.entryAction: entryActionFor(lesson.status),
      AnalyticsParams.destinationScreen: 'role_play_vocabulary_lesson',
    });

    if (lesson.status == LearningLessonStatus.notStarted) {
      await _dailyLessonRepository.recordLessonStartedPath(
        typeId: RoleplayPracticeType.vocabulary.id,
        scopeId: _scenarioId,
        lessonId: lesson.lessonId,
      );
    }
    if (!context.mounted) return;

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
          cefrLevel: _cefrLevel,
          entryAction: entryActionFor(lesson.status),
          learningArea: 'role_play',
          scenarioId: _scenarioId,
          completionXpEarned: RoleplayXpRewards.vocabulary,
        ),
      ),
    );
  }

  Future<void> _saveInProgress(VocabularyLessonModel lesson, int index) async {
    await _progressRepository.saveInProgress(
      lessonId: lesson.lessonId,
      type: RoleplayPracticeType.vocabulary.id,
      cefrLevel: _cefrLevel,
      currentIndex: index,
    );
    await _syncService.onProgressChanged(
      LessonProgressModel(
        lessonId: lesson.lessonId,
        type: RoleplayPracticeType.vocabulary.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.inProgress,
        currentIndex: index,
        updatedAt: DateTime.now(),
      ),
    );
    await _loadLessons();
  }

  Future<List<String>> _markLessonCompleted(
    VocabularyLessonModel completedLesson,
  ) async {
    await _progressRepository.initialize();
    final existing =
        await _progressRepository.getProgress(completedLesson.lessonId);
    final orderedIds = _lessons.map((l) => l.lessonId).toList();
    final nextId = LessonUnlockLogic.nextLessonIdToUnlock(
      completedLessonId: completedLesson.lessonId,
      orderedLessonIds: orderedIds,
    );
    VocabularyLessonModel? nextLesson;
    if (nextId != null) {
      for (final candidate in _lessons) {
        if (candidate.lessonId == nextId) {
          nextLesson = candidate;
          break;
        }
      }
    }
    final alreadyCompleted =
        existing?.status == LearningLessonStatus.completed;

    if (alreadyCompleted) {
      _syncService.lastCompletionXpGranted = 0;
      _syncService.lastModuleCompletionBonusXp = 0;
      _syncService.rememberNextLesson(
        nextLessonId: nextId,
        nextLessonNumber: nextLesson?.number,
        nextWasLocked: false,
        alreadyCompleted: true,
      );
      await _loadLessons();
      return [];
    }

    await _progressRepository.markCompleted(
      lessonId: completedLesson.lessonId,
      type: RoleplayPracticeType.vocabulary.id,
      cefrLevel: _cefrLevel,
      finalIndex: completedLesson.totalWords,
    );

    await _dailyLessonRepository.recordLessonCompletedPath(
      typeId: RoleplayPracticeType.vocabulary.id,
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
        type: RoleplayPracticeType.vocabulary.id,
        cefrLevel: _cefrLevel,
        status: LearningLessonStatus.completed,
        currentIndex: completedLesson.totalWords,
        updatedAt: DateTime.now(),
        completedAt: DateTime.now(),
      ),
      xpAmount: RoleplayXpRewards.vocabulary,
      scenarioId: _scenarioId,
      lessonNumber: completedLesson.number,
      wordsLearned: completedLesson.totalWords,
    );

    _syncService.rememberNextLesson(
      nextLessonId: nextId,
      nextLessonNumber: nextLesson?.number,
      nextWasLocked: nextLesson?.status == LearningLessonStatus.locked,
      alreadyCompleted: false,
    );

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
