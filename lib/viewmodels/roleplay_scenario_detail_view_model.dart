import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/roleplay_content_repository.dart';
import 'package:fluentta_ai/data/services/learning_stats_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

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

  CefrLevel get selectedLevel => _selectedLevel;
  double get moduleProgress => _moduleProgress;
  bool get isLoading => _isLoading;
  int get totalXp => _learningStatsService.xpEarned;

  void selectLevel(CefrLevel level) {
    if (_selectedLevel == level) return;
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

    if (!_didSetInitialLevel) {
      _selectedLevel = CefrLevelProgress.highestUnlockedTab(totalXp);
      _didSetInitialLevel = true;
    }

    _isLoading = false;
    notifyListeners();
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
