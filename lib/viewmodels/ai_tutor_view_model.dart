import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_milestones.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/models/roleplay_scenario_model.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';

class AiTutorViewModel extends ChangeNotifier {
  AiTutorViewModel(this._homeViewModel);

  final HomeViewModel _homeViewModel;

  String? _selectedScenarioId;

  int get lives => _homeViewModel.lives;
  String? get selectedScenarioId => _selectedScenarioId;

  /// PRD 4.2.7 — the scenario's earliest (A1) version is XP-unlocked.
  bool isScenarioXpUnlocked(String id) =>
      RoleplayXpMilestones.isScenarioUnlocked(id, _homeViewModel.xpEarned);

  int scenarioUnlockXp(String id) =>
      RoleplayXpMilestones.xpRequiredFor(id, CefrLevel.a1);

  /// How much more XP is needed to unlock [id] — the number to show the
  /// learner so they know what's left, not just the flat total required.
  int scenarioXpRemaining(String id) {
    final remaining = scenarioUnlockXp(id) - _homeViewModel.xpEarned;
    return remaining < 0 ? 0 : remaining;
  }

  static final List<RoleplayScenarioModel> scenarios = [
    RoleplayScenarioModel(
      id: 'job_interviews',
      title: 'Job Interviews',
      icon: Icons.work_outline_rounded,
      imagePath: AppAssets.jobInterviews,
      progress: 0.20,
    ),
    RoleplayScenarioModel(
      id: 'order_food',
      title: 'Order Food',
      icon: Icons.restaurant_outlined,
      imagePath: AppAssets.orderFood,
      progress: 0.10,
    ),
    RoleplayScenarioModel(
      id: 'at_airport',
      title: 'At Airport',
      icon: Icons.flight_outlined,
      imagePath: AppAssets.atAirport,
      progress: 0.0,
    ),
    RoleplayScenarioModel(
      id: 'doctor_visit',
      title: "Doctor's Visit",
      icon: Icons.local_hospital_outlined,
      imagePath: AppAssets.doctorVisit,
      progress: 0.35,
    ),
    RoleplayScenarioModel(
      id: 'small_talk',
      title: 'Small Talk',
      icon: Icons.chat_bubble_outline_rounded,
      imagePath: AppAssets.smallTalk,
      progress: 0.15,
    ),
    RoleplayScenarioModel(
      id: 'business_meeting',
      title: 'Business Meeting',
      icon: Icons.groups_outlined,
      imagePath: AppAssets.businessMeeting,
      progress: 0.05,
    ),
  ];

  static RoleplayScenarioModel? scenarioById(String id) {
    for (final scenario in scenarios) {
      if (scenario.id == id) return scenario;
    }
    return null;
  }

  void selectScenario(String id) {
    _selectedScenarioId = id;
    notifyListeners();
  }

  String? get selectedScenarioTitle {
    if (_selectedScenarioId == null) return null;
    return scenarios.firstWhere((s) => s.id == _selectedScenarioId).title;
  }
}
