import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_milestones.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/learning_stats_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

/// Analytics `module_state` for a roleplay practice tile.
enum RoleplayModuleState { notStarted, inProgress, completed, locked }

extension RoleplayModuleStateAnalytics on RoleplayModuleState {
  String get analyticsValue => switch (this) {
        RoleplayModuleState.notStarted => 'not_started',
        RoleplayModuleState.inProgress => 'in_progress',
        RoleplayModuleState.completed => 'completed',
        RoleplayModuleState.locked => 'locked',
      };
}

class RoleplayScenarioDetailViewModel extends ChangeNotifier {
  RoleplayScenarioDetailViewModel({
    required this.scenarioId,
    required LearningStatsService learningStatsService,
    required RoleplayContentRepository contentRepository,
    required ProgressRepository progressRepository,
    required ProgressSyncService progressSyncService,
  })  : _learningStatsService = learningStatsService,
        _contentRepository = contentRepository,
        _progressRepository = progressRepository,
        _progressSyncService = progressSyncService {
    _progressSyncService.addMergeListener(_onProgressMerged);
    _load();
  }

  final String scenarioId;
  final LearningStatsService _learningStatsService;
  final RoleplayContentRepository _contentRepository;
  final ProgressRepository _progressRepository;
  final ProgressSyncService _progressSyncService;

  CefrLevel _selectedLevel = CefrLevel.a1;
  double _moduleProgress = 0;
  bool _isLoading = true;
  bool _didSetInitialLevel = false;

  RoleplayModuleState _dialogueState = RoleplayModuleState.notStarted;
  RoleplayModuleState _vocabularyState = RoleplayModuleState.notStarted;
  RoleplayModuleState _comprehensionState = RoleplayModuleState.notStarted;
  int _completedModuleCount = 0;

  CefrLevel get selectedLevel => _selectedLevel;
  double get moduleProgress => _moduleProgress;
  bool get isLoading => _isLoading;
  int get totalXp => _learningStatsService.xpEarned;

  /// Analytics `completed_module_count` — how many of the 3 practice modules
  /// (dialogue/vocabulary/comprehension) are fully completed.
  int get completedModuleCount => _completedModuleCount;

  RoleplayModuleState get dialogueModuleState => _dialogueState;
  RoleplayModuleState get vocabularyModuleState => _vocabularyState;
  RoleplayModuleState get comprehensionModuleState => _comprehensionState;

  /// PRD 4.2.7 — this scenario's level opens at its cumulative XP milestone.
  bool isLevelUnlocked(CefrLevel level) =>
      RoleplayXpMilestones.isScenarioLevelUnlocked(scenarioId, level, totalXp);

  int xpRequiredForLevel(CefrLevel level) =>
      RoleplayXpMilestones.xpRequiredFor(scenarioId, level);

  void selectLevel(CefrLevel level) {
    if (_selectedLevel == level) return;
    if (!isLevelUnlocked(level)) return;
    _selectedLevel = level;
    notifyListeners();
  }

  Future<void> reload() => _load();

  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();

    await _contentRepository.initialize();
    await _progressRepository.initialize();

    _moduleProgress = await _contentRepository.scenarioModuleProgress(
      scenarioId: scenarioId,
      progressRepository: _progressRepository,
    );

    final dialogueLessons = await _contentRepository.buildDialogueLessons(
      scenarioId: scenarioId,
      progressRepository: _progressRepository,
    );
    final vocabularyLessons = await _contentRepository.buildVocabularyLessons(
      scenarioId: scenarioId,
      progressRepository: _progressRepository,
    );
    final comprehensionLessons =
        await _contentRepository.buildQuickCheckLessons(
      scenarioId: scenarioId,
      progressRepository: _progressRepository,
    );
    _dialogueState = _moduleStateFor(
      dialogueLessons.map((l) => l.status).toList(),
    );
    _vocabularyState = _moduleStateFor(
      vocabularyLessons.map((l) => l.status).toList(),
    );
    _comprehensionState = _moduleStateFor(
      comprehensionLessons.map((l) => l.status).toList(),
    );
    _completedModuleCount = [
      _dialogueState,
      _vocabularyState,
      _comprehensionState,
    ].where((s) => s == RoleplayModuleState.completed).length;

    if (!_didSetInitialLevel) {
      _selectedLevel =
          RoleplayXpMilestones.highestUnlockedLevel(scenarioId, totalXp) ??
              CefrLevel.a1;
      _didSetInitialLevel = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  RoleplayModuleState _moduleStateFor(List<LearningLessonStatus> statuses) {
    if (statuses.isEmpty) return RoleplayModuleState.notStarted;
    if (statuses.every((s) => s == LearningLessonStatus.completed)) {
      return RoleplayModuleState.completed;
    }
    if (statuses.any(
      (s) =>
          s == LearningLessonStatus.completed ||
          s == LearningLessonStatus.inProgress,
    )) {
      return RoleplayModuleState.inProgress;
    }
    if (statuses.first == LearningLessonStatus.locked) {
      return RoleplayModuleState.locked;
    }
    return RoleplayModuleState.notStarted;
  }

  void _onProgressMerged() {
    _load();
  }

  @override
  void dispose() {
    _progressSyncService.removeMergeListener(_onProgressMerged);
    super.dispose();
  }
}
