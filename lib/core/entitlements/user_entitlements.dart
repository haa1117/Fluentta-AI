import 'package:fluentta_ai/core/cefr/cefr_level.dart';

/// Free vs Pro feature limits for Fluentta.
class UserEntitlements {
  UserEntitlements._();

  static const int freeDailyHearts = 5;
  static const int freeStreakFreezesPerWeek = 2;
  static const int proStreakRepairsPerMonth = 1;

  /// Two beginner roleplay scenarios included on the free plan.
  static const Set<String> freeRoleplayScenarioIds = {
    'order_food',
    'small_talk',
  };

  static const Set<String> advancedRoleplayScenarioIds = {
    'job_interviews',
    'at_airport',
    'doctor_visit',
    'business_meeting',
  };

  static bool isPro(bool isPremium) => isPremium;

  static bool hasUnlimitedHearts(bool isPremium) => isPremium;

  static bool canAccessRoleplayScenario(String scenarioId, bool isPremium) {
    if (isPremium) return true;
    return freeRoleplayScenarioIds.contains(scenarioId);
  }

  static bool isRoleplayScenarioLocked(String scenarioId, bool isPremium) {
    return !canAccessRoleplayScenario(scenarioId, isPremium);
  }

  /// Free users can study A1–B1 lesson paths. B2+ requires Pro.
  static bool canAccessCefrLevel(CefrLevel level, bool isPremium) {
    if (isPremium) return true;
    return level.index <= CefrLevel.b1.index;
  }

  static bool canAccessSetupLevel(String? setupLevelId, bool isPremium) {
    if (isPremium) return true;
    final level = CefrLevel.fromSetupId(setupLevelId);
    return canAccessCefrLevel(level, isPremium);
  }

  /// Lesson content level used for free users capped at B1.
  static CefrLevel contentLevelForUser(String? setupLevelId, bool isPremium) {
    final selected = CefrLevel.fromSetupId(setupLevelId);
    if (isPremium) return selected;
    if (selected.index <= CefrLevel.b1.index) return selected;
    return CefrLevel.b1;
  }

  static int streakFreezesAllowance(bool isPremium) {
    return isPremium ? 999999 : freeStreakFreezesPerWeek;
  }

  static bool canRepairStreak(bool isPremium) => isPremium;

  static bool canUseOfflineMode(bool isPremium) => isPremium;

  static bool canViewWeeklyProgressReport(bool isPremium) => isPremium;
}
