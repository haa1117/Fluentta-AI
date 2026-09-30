import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/network/connectivity_view_model.dart';
import 'package:fluentta_ai/widgets/ads/connect_to_watch_ad_dialog.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_milestones.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/newly_unlocked_content.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

/// Tapping the XP stat opens this — everything unlocked so far, what's
/// coming next, and a "Watch Ad" CTA to top up XP outside a lesson.
///
/// This is a shared/global modal — [sourceScreen] must be threaded through
/// from whichever screen's XP badge opened it (never hardcoded here).
Future<void> showXpUnlockedDialog(
  BuildContext context, {
  String sourceScreen = 'unknown',
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _XpUnlockedDialog(sourceScreen: sourceScreen),
  );
}

class _XpUnlockedDialog extends StatefulWidget {
  const _XpUnlockedDialog({required this.sourceScreen});

  final String sourceScreen;

  @override
  State<_XpUnlockedDialog> createState() => _XpUnlockedDialogState();
}

class _XpUnlockedDialogState extends State<_XpUnlockedDialog> {
  bool _isWatchingAd = false;
  bool _loggedViewed = false;

  /// Nearest unlock ahead is either a CEFR level or a roleplay scenario
  /// stage; recomputed locally (rather than extending
  /// [NewlyUnlockedContent], which only returns a label) to classify it.
  String _nextUnlockType(int totalXp) {
    int? nextCefrXp;
    for (final level in CefrLevelProgress.tabLevels) {
      if (level == CefrLevel.a1) continue;
      final threshold = CefrLevelProgress.xpRequiredFor(level);
      if (threshold > totalXp && (nextCefrXp == null || threshold < nextCefrXp)) {
        nextCefrXp = threshold;
      }
    }
    int? nextRoleplayXp;
    for (final scenarioId in RoleplayXpMilestones.stageOffset.keys) {
      for (final level in CefrLevel.values) {
        final threshold = RoleplayXpMilestones.xpRequiredFor(scenarioId, level);
        if (threshold > totalXp &&
            (nextRoleplayXp == null || threshold < nextRoleplayXp)) {
          nextRoleplayXp = threshold;
        }
      }
    }
    if (nextCefrXp == null && nextRoleplayXp == null) return 'none';
    if (nextCefrXp == null) return 'roleplay';
    if (nextRoleplayXp == null) return 'cefr_level';
    return nextRoleplayXp < nextCefrXp ? 'roleplay' : 'cefr_level';
  }

  void _logViewedOnce(int totalXp, ({String label, int xpNeeded})? next) {
    if (_loggedViewed) return;
    _loggedViewed = true;
    final entitlements = context.read<EntitlementsService>();
    AnalyticsService.instance.log(AnalyticsEvents.xpViewed, {
      AnalyticsParams.sourceScreen: widget.sourceScreen,
      AnalyticsParams.currentXp: totalXp,
      AnalyticsParams.currentCefrLevel: entitlements.setupLevel().code,
      AnalyticsParams.nextUnlockType: _nextUnlockType(totalXp),
      AnalyticsParams.xpToNextUnlock: next?.xpNeeded ?? 0,
    });
  }

  Future<void> _watchAd() async {
    final l10n = context.l10n;
    final ready = await ensureOnlineForRewardedAd(context);
    if (!ready || !mounted) return;
    final home = context.read<HomeViewModel>();
    if (!home.canWatchXpBoostAd) {
      await _showCapReachedDialog();
      return;
    }
    setState(() => _isWatchingAd = true);

    final result = await home.watchAdForXp();
    if (!mounted) return;
    setState(() => _isWatchingAd = false);

    switch (result) {
      case XpBoostResult.granted:
        SnackbarHelper.showSuccess(
          context,
          l10n.xpBoostApplied(HomeViewModel.rewardedXpBoostAmount),
        );
      case XpBoostResult.dailyCapReached:
        await _showCapReachedDialog();
      case XpBoostResult.adUnavailable:
        SnackbarHelper.showError(context, l10n.adNotAvailable);
    }
  }

  Future<void> _showCapReachedDialog() {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
          title: Text(
            l10n.watchAd,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(18),
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          ),
          content: Text(
            l10n.xpBoostCapReached,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              height: 1.4,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: HapticService.wrap(() => Navigator.of(dialogContext).pop()),
              child: Text(
                l10n.done,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final home = context.watch<HomeViewModel>();
    context.watch<ConnectivityViewModel>();
    final totalXp = home.xpEarned;

    final unlocked = NewlyUnlockedContent.allUnlockedSoFar(
      l10n: l10n,
      totalXp: totalXp,
    );
    final next = NewlyUnlockedContent.nextUnlock(l10n: l10n, totalXp: totalXp);
    _logViewedOnce(totalXp, next);

    return Dialog(
      backgroundColor: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  color: AppColors.xpEarnedTextColor,
                  size: AppSizes.sp(24),
                ),
                SizedBox(width: AppSizes.w(8)),
                Expanded(
                  child: Text(
                    l10n.whatsUnlockedTitle,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(18),
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: HapticService.wrap(() => Navigator.of(context).pop()),
                  child: Icon(
                    Icons.close_rounded,
                    size: AppSizes.sp(20),
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.iconColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h(4)),
            Text(
              l10n.xpTotalLabel(totalXp),
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(13),
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.xpEarnedTextColorDark
                    : AppColors.xpEarnedTextColor,
              ),
            ),
            SizedBox(height: AppSizes.spaceMd),
            if (unlocked.isEmpty)
              Text(
                l10n.nothingUnlockedYet,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  height: 1.4,
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: AppSizes.h(220)),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: AppSizes.w(8),
                    runSpacing: AppSizes.h(8),
                    children: unlocked
                        .map(
                          (label) => Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.w(14),
                              vertical: AppSizes.h(8),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.chipBackgroundColor,
                              borderRadius: BorderRadius.circular(AppSizes.w(20)),
                              border: Border.all(color: AppColors.chipBorderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: AppSizes.sp(14),
                                  color: AppColors.learnSuccessGreen,
                                ),
                                SizedBox(width: AppSizes.w(6)),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontFamily: AppFonts.plusJakartaSans,
                                    fontSize: AppSizes.sp(13),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlueColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            if (next != null) ...[
              SizedBox(height: AppSizes.spaceMd),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.w(12)),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.brandDarkSoftColor
                      : AppColors.homeCardLavender,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.nextUnlockLabel(next.label, next.xpNeeded),
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primaryColor,
                  ),
                ),
              ),
            ],
            SizedBox(height: AppSizes.spaceLg),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: HapticService.wrap(_isWatchingAd ? null : _watchAd),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.w(28)),
                    ),
                  ),
                  child: _isWatchingAd
                      ? SizedBox(
                          width: AppSizes.sp(20),
                          height: AppSizes.sp(20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.watchAd,
                              style: TextStyle(
                                fontFamily: AppFonts.plusJakartaSans,
                                fontSize: AppSizes.sp(15),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l10n.watchAdForXpSub(
                                HomeViewModel.rewardedXpBoostAmount,
                              ),
                              style: TextStyle(
                                fontFamily: AppFonts.plusJakartaSans,
                                fontSize: AppSizes.sp(11),
                                fontWeight: FontWeight.w500,
                                color: AppColors.white.withValues(alpha: 0.85),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
