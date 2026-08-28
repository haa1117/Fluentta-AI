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

  static bool isLevelUnlocked(int totalXp, CefrLevel level) {
    return totalXp >= xpRequiredFor(level);
  }

  static CefrLevel highestUnlockedTab(int totalXp) {
    CefrLevel result = CefrLevel.a1;
    for (final level in tabLevels) {
      if (isLevelUnlocked(totalXp, level)) {
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
