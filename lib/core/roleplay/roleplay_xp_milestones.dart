import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';

/// PRD 4.2.7 — Roleplay scenarios unlock progressively as the learner reaches
/// cumulative XP milestones. Each milestone is expressed as XP *into* the
/// current CEFR stage and repeats at every stage from the new baseline.
///
/// Example (A1 stage baseline = 0 XP):
///   Small Talk        → 100 XP
///   Order Food        → 225 XP
///   At the Airport    → 350 XP
///   Doctor's Visit    → 475 XP
///   Job Interview     → 625 XP
///   Business Meeting  → 775 XP
///
/// At A2 (baseline 1,000 XP) the same offsets apply: Small Talk → 1,100 XP, etc.
class RoleplayXpMilestones {
  RoleplayXpMilestones._();

  /// XP into the current CEFR stage at which each scenario opens.
  static const Map<String, int> stageOffset = {
    'small_talk': 100,
    'order_food': 225,
    'at_airport': 350,
    'doctor_visit': 475,
    'job_interviews': 625,
    'business_meeting': 775,
  };

  /// Absolute cumulative XP needed for [scenarioId] at [level].
  static int xpRequiredFor(String scenarioId, CefrLevel level) {
    final offset = stageOffset[scenarioId] ?? 0;
    return CefrLevelProgress.xpRequiredFor(level) + offset;
  }

  /// Whether the (scenario, level) pair has been reached by [totalXp].
  static bool isScenarioLevelUnlocked(
    String scenarioId,
    CefrLevel level,
    int totalXp,
  ) {
    return totalXp >= xpRequiredFor(scenarioId, level);
  }

  /// Whether the scenario is available at all (its earliest — A1 — milestone).
  static bool isScenarioUnlocked(String scenarioId, int totalXp) {
    return isScenarioLevelUnlocked(scenarioId, CefrLevel.a1, totalXp);
  }

  /// Highest CEFR level of [scenarioId] the learner has unlocked, or null if
  /// even the A1 version is still locked.
  static CefrLevel? highestUnlockedLevel(String scenarioId, int totalXp) {
    CefrLevel? result;
    for (final level in CefrLevel.values) {
      if (isScenarioLevelUnlocked(scenarioId, level, totalXp)) {
        result = level;
      }
    }
    return result;
  }
}
