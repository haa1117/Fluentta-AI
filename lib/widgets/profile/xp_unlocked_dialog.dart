import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/core/xp/newly_unlocked_content.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

/// Tapping the XP stat opens this — everything unlocked so far, what's
/// coming next, and a "Watch Ad" CTA to top up XP outside a lesson.
Future<void> showXpUnlockedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => const _XpUnlockedDialog(),
  );
}

class _XpUnlockedDialog extends StatefulWidget {
  const _XpUnlockedDialog();

  @override
  State<_XpUnlockedDialog> createState() => _XpUnlockedDialogState();
}

class _XpUnlockedDialogState extends State<_XpUnlockedDialog> {
  bool _isWatchingAd = false;

  Future<void> _watchAd() async {
    final l10n = context.l10n;
    final home = context.read<HomeViewModel>();
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
        SnackbarHelper.showError(context, l10n.xpBoostCapReached);
      case XpBoostResult.adUnavailable:
        SnackbarHelper.showError(context, l10n.adNotAvailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final home = context.watch<HomeViewModel>();
    final totalXp = home.xpEarned;

    final unlocked = NewlyUnlockedContent.allUnlockedSoFar(
      l10n: l10n,
      totalXp: totalXp,
    );
    final next = NewlyUnlockedContent.nextUnlock(l10n: l10n, totalXp: totalXp);

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
                  onTap: () => Navigator.of(context).pop(),
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
                onPressed: (home.canWatchXpBoostAd && !_isWatchingAd)
                    ? _watchAd
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: AppColors.progressTrack,
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
                            home.canWatchXpBoostAd
                                ? l10n.watchAdForXpSub(
                                    HomeViewModel.rewardedXpBoostAmount)
                                : l10n.xpBoostCapReached,
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
