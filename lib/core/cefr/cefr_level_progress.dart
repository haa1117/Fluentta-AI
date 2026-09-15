import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

/// CEFR tab unlock thresholds (cumulative XP gates).
class CefrLevelProgress {
  CefrLevelProgress._();

  static const tabLevels = [
    CefrLevel.a1,
    CefrLevel.a2,
    CefrLevel.b1,
    CefrLevel.b2,
    CefrLevel.c1,
  ];

  static int xpRequiredFor(CefrLevel level) {
    return switch (level) {
      CefrLevel.a1 => 0,
      CefrLevel.a2 => 1000,
      CefrLevel.b1 => 2000,
      CefrLevel.b2 => 3000,
      CefrLevel.c1 => 4000,
      CefrLevel.c2 => 5000,
    };
  }

  /// The level a learner must finish before [level] opens (null for A1).
  static CefrLevel? previousLevel(CefrLevel level) {
    if (level.index == 0) return null;
    return CefrLevel.values[level.index - 1];
  }

  /// PRD 4.2.4 — a CEFR level unlocks only when BOTH the cumulative XP gate is
  /// reached AND all 30 core lessons of the previous level are completed.
  ///
  /// [previousLevelCoreComplete] defaults to `true` so callers that only have
  /// XP available still behave sensibly; pass the real value where progress
  /// data is available (Learn tab, CEFR celebration).
  static bool isLevelUnlocked(
    int totalXp,
    CefrLevel level, {
    bool previousLevelCoreComplete = true,
  }) {
    if (level.index == 0) return true;
    if (totalXp < xpRequiredFor(level)) return false;
    return previousLevelCoreComplete;
  }

  static CefrLevel highestUnlockedTab(
    int totalXp, {
    bool Function(CefrLevel level)? isCoreComplete,
  }) {
    CefrLevel result = CefrLevel.a1;
    for (final level in tabLevels) {
      final prev = previousLevel(level);
      final coreOk =
          prev == null || (isCoreComplete?.call(prev) ?? true);
      if (isLevelUnlocked(totalXp, level, previousLevelCoreComplete: coreOk)) {
        result = level;
      }
    }
    return result;
  }

  static String levelCodeLabel(AppLocalizations l10n, CefrLevel level) {
    return switch (level) {
      CefrLevel.a1 => l10n.levelA1,
      CefrLevel.a2 => l10n.levelA2,
      CefrLevel.b1 => l10n.levelB1,
      CefrLevel.b2 => l10n.levelB2,
      CefrLevel.c1 => l10n.levelC1,
      CefrLevel.c2 => l10n.levelC2,
    };
  }

  static String levelNameLabel(AppLocalizations l10n, CefrLevel level) {
    return switch (level) {
      CefrLevel.a1 => l10n.levelBeginner,
      CefrLevel.a2 => l10n.levelElementary,
      CefrLevel.b1 => l10n.levelIntermediate,
      CefrLevel.b2 => l10n.levelUpperIntermediate,
      CefrLevel.c1 => l10n.levelAdvancedC1,
      CefrLevel.c2 => l10n.levelProficientC2,
    };
  }
}
