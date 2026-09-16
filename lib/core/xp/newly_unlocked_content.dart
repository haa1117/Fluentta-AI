import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_milestones.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

/// PRD 4.2.4 / 4.2.7 — an XP gain that crosses an unlock threshold should be
/// surfaced to the learner right when it happens, not left for them to
/// discover by browsing to a locked screen. This scans every CEFR-level and
/// roleplay-scenario threshold between [xpBefore] (exclusive) and [xpAfter]
/// (inclusive) and returns a human-readable label for each one just opened.
class NewlyUnlockedContent {
  NewlyUnlockedContent._();

  static List<String> compute({
    required AppLocalizations l10n,
    required int xpBefore,
    required int xpAfter,
  }) {
    try {
      return _compute(l10n: l10n, xpBefore: xpBefore, xpAfter: xpAfter);
    } catch (_) {
      return [];
    }
  }

  static List<String> _compute({
    required AppLocalizations l10n,
    required int xpBefore,
    required int xpAfter,
  }) {
    if (xpAfter <= xpBefore) return [];

    final crossed = <(int threshold, String label)>[];

    for (final level in CefrLevelProgress.tabLevels) {
      if (level == CefrLevel.a1) continue; // always unlocked, never "new"
      final threshold = CefrLevelProgress.xpRequiredFor(level);
      if (threshold > xpBefore && threshold <= xpAfter) {
        crossed.add((
          threshold,
          '${CefrLevelProgress.levelNameLabel(l10n, level)} '
              '(${CefrLevelProgress.levelCodeLabel(l10n, level)})',
        ));
      }
    }

    for (final scenarioId in RoleplayXpMilestones.stageOffset.keys) {
      for (final level in CefrLevel.values) {
        final threshold = RoleplayXpMilestones.xpRequiredFor(scenarioId, level);
        if (threshold > xpBefore && threshold <= xpAfter) {
          crossed.add((
            threshold,
            '${_scenarioLabel(l10n, scenarioId)} '
                '(${CefrLevelProgress.levelCodeLabel(l10n, level)})',
          ));
        }
      }
    }

    crossed.sort((a, b) => a.$1.compareTo(b.$1));
    return crossed.map((entry) => entry.$2).toList();
  }

  static String _scenarioLabel(AppLocalizations l10n, String scenarioId) {
    return switch (scenarioId) {
      'small_talk' => l10n.scenarioSmallTalk,
      'order_food' => l10n.scenarioOrderFood,
      'at_airport' => l10n.scenarioAtAirport,
      'doctor_visit' => l10n.scenarioDoctorVisit,
      'job_interviews' => l10n.scenarioJobInterviews,
      'business_meeting' => l10n.scenarioBusinessMeeting,
      _ => scenarioId,
    };
  }
}
