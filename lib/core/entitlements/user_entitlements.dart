import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';

/// Free vs Pro feature limits for Fluentta.
class UserEntitlements {
  UserEntitlements._();

  static const int freeDailyHearts = 5;
  static const int freeStreakFreezesPerWeek = 2;
  static const int proStreakRepairsPerMonth = 1;

  /// PRD 4.2.13 — rewarded heart refill.
  static const int rewardedHeartRefillAmount = 2;
  static const int maxHeartRefillAdsPerDay = 3;

  /// PRD 4.4 / 8.2 — post-lesson interstitial cadence (free tier).
  static const int lessonsPerInterstitial = 3;

  /// PRD 4.2.4 — required core lessons (10 vocab + 10 grammar + 10 reading).
  static const int coreLessonsPerLevel = 30;

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

  /// PRD 4.2.4 — a CEFR level is unlocked when the cumulative XP gate is met
  /// AND every core lesson of the previous level is complete.
  static bool isCefrLevelUnlocked(
    LocalStorage storage,
    ProgressRepository progress,
    CefrLevel level,
  ) {
    final prev = CefrLevelProgress.previousLevel(level);
    return CefrLevelProgress.isLevelUnlocked(
      storage.xpEarned,
      level,
      previousLevelCoreComplete:
          prev == null || progress.isCoreCurriculumComplete(prev),
    );
  }

  /// Level selected on the Learn tab (falls back to highest unlocked tab).
  static CefrLevel learnBrowseLevel(
    LocalStorage storage,
    ProgressRepository progress,
  ) {
    final code = storage.learnBrowseCefrLevelCode;
    if (code != null) {
      final level = CefrLevel.fromCode(code);
      if (isCefrLevelUnlocked(storage, progress, level) &&
          canAccessCefrLevel(level, storage.isPremium)) {
        return level;
      }
    }
    return CefrLevelProgress.highestUnlockedTab(
      storage.xpEarned,
      isCoreComplete: progress.isCoreCurriculumComplete,
    );
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

  /// Self-rated CEFR from setup. Used by the AI tutor; not gated by plan.
  static CefrLevel setupLevel(String? setupLevelId) =>
      CefrLevel.fromSetupId(setupLevelId);

  static int streakFreezesAllowance(bool isPremium) {
    return isPremium ? 999999 : freeStreakFreezesPerWeek;
  }

  static bool canRepairStreak(bool isPremium) => isPremium;

  /// Bundled lessons, roleplay, pronunciation, and local progress work
  /// without internet for free and Pro. AI chat is gated separately.
  static bool canUseOfflineMode(bool isPremium) => true;

  static bool canViewWeeklyProgressReport(bool isPremium) => isPremium;
}
