import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/widgets/ads/connect_to_watch_ad_dialog.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/subscription/subscription_screen.dart';
import 'package:fluentta_ai/widgets/common/action_option_card.dart';
import 'package:fluentta_ai/widgets/common/premium_upsell_sheet_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Simple v4-shaped random id (no `uuid` package dependency) — good enough
/// to correlate the events of a single out-of-hearts recovery journey.
String _generateJourneyId() {
  final random = Random();
  const chars = '0123456789abcdef';
  String hex(int length) =>
      List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${chars[8 + random.nextInt(4)]}${hex(3)}-${hex(12)}';
}

/// Shared upsell bottom sheet (out-of-hearts + Pro-locked features).
///
/// [onShown] fires as the sheet renders; [onGoUnlimitedTapped] fires when the
/// "Go Unlimited" CTA is tapped; [onDismissedWithoutAction] fires once the
/// sheet closes any other way (close button, swipe, tap-outside). These are
/// analytics hooks only — default to null and change no existing behavior.
Future<void> showPremiumUpsellBottomSheet(
  BuildContext context, {
  PremiumUpsellSheetConfig config = const PremiumUpsellSheetConfig(),
  VoidCallback? onShown,
  VoidCallback? onGoUnlimitedTapped,
  VoidCallback? onDismissedWithoutAction,
}) {
  AppSizes.init(context);
  var actionTaken = false;

  final sheetFuture = showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (sheetContext) {
      onShown?.call();
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: OutOfHeartsBottomSheet(
          config: config,
          onClose: () => Navigator.of(sheetContext).pop(),
          onGoUnlimited: () {
            actionTaken = true;
            onGoUnlimitedTapped?.call();
            Navigator.of(sheetContext).pop();
            SubscriptionScreen.open(context, featureTrigger: 'out_of_hearts');
          },
          onWatchAd: () async {
            final l10n = sheetContext.l10n;
            final ready = await ensureOnlineForRewardedAd(sheetContext);
            if (!ready || !sheetContext.mounted) return;
            final home = sheetContext.read<HomeViewModel>();
            final result = await home.watchAdForHearts();
            if (!sheetContext.mounted) return;
            Navigator.of(sheetContext).pop();
            if (!context.mounted) return;
            switch (result) {
              case HeartRefillResult.granted:
                SnackbarHelper.showSuccess(
                  context,
                  l10n.heartsRefilledMessage(home.rewardedHeartRefillAmount),
                );
              case HeartRefillResult.dailyCapReached:
                SnackbarHelper.showError(context, l10n.heartRefillCapReached);
              case HeartRefillResult.adUnavailable:
                SnackbarHelper.showError(context, l10n.adNotAvailable);
              case HeartRefillResult.notNeeded:
                break;
            }
          },
        ),
      );
    },
  );

  return sheetFuture.then((_) {
    if (!actionTaken) {
      onDismissedWithoutAction?.call();
    }
  });
}

/// Shows the out-of-hearts bottom sheet when the user has no hearts left.
///
/// [featureContext] and [blockedAction] identify what the learner was
/// trying to do (e.g. `ai_chat` / `submit_ai_chat_message`), and
/// [sourceScreen] the screen they were on — required so the Hearts-recovery
/// analytics (`out_of_hearts_viewed`, `go_unlimited_clicked`,
/// `out_of_hearts_dismissed`) carry real context instead of being
/// hardcoded, since this sheet is shared across every heart-gated feature.
Future<void> showOutOfHeartsBottomSheet(
  BuildContext context, {
  required String sourceScreen,
  required String featureContext,
  required String blockedAction,
  PremiumUpsellSheetConfig config = const PremiumUpsellSheetConfig(),
}) {
  AppSizes.init(context);
  final home = context.read<HomeViewModel>();
  if (home.hasUnlimitedHearts) {
    return Future.value();
  }

  final entitlements = context.read<EntitlementsService>();
  final recoveryJourneyId = _generateJourneyId();
  home.recordHeartGateBlocked(
    featureContext: featureContext,
    blockedAction: blockedAction,
    sourceScreen: sourceScreen,
    recoveryJourneyId: recoveryJourneyId,
  );

  return showPremiumUpsellBottomSheet(
    context,
    config: config,
    onShown: () {
      AnalyticsService.instance.log(AnalyticsEvents.outOfHeartsViewed, {
        AnalyticsParams.sourceScreen: sourceScreen,
        AnalyticsParams.featureContext: featureContext,
        AnalyticsParams.blockedAction: blockedAction,
        AnalyticsParams.heartBalance: 0,
        AnalyticsParams.subscriptionTierAtEvent:
            entitlements.isPro ? 'premium' : 'free',
        AnalyticsParams.recoveryJourneyId: recoveryJourneyId,
      });
    },
    onGoUnlimitedTapped: () {
      AnalyticsService.instance.log(AnalyticsEvents.goUnlimitedClicked, {
        AnalyticsParams.sourceScreen: sourceScreen,
        AnalyticsParams.sourceModal: 'out_of_hearts',
        AnalyticsParams.featureContext: featureContext,
        AnalyticsParams.blockedAction: blockedAction,
        AnalyticsParams.destinationScreen: 'paywall',
        AnalyticsParams.featureTrigger: 'out_of_hearts',
        AnalyticsParams.recoveryJourneyId: recoveryJourneyId,
      });
    },
    onDismissedWithoutAction: () {
      AnalyticsService.instance.log(AnalyticsEvents.outOfHeartsDismissed, {
        AnalyticsParams.sourceScreen: sourceScreen,
        AnalyticsParams.featureContext: featureContext,
        AnalyticsParams.blockedAction: blockedAction,
        AnalyticsParams.recoveryJourneyId: recoveryJourneyId,
      });
    },
  );
}

/// Reusable upsell UI. Used for out-of-hearts and Pro-locked features.
class OutOfHeartsBottomSheet extends StatelessWidget {
  const OutOfHeartsBottomSheet({
    super.key,
    required this.onClose,
    required this.onGoUnlimited,
    required this.onWatchAd,
    this.config = const PremiumUpsellSheetConfig(),
  });

  final VoidCallback onClose;
  final VoidCallback onGoUnlimited;
  final VoidCallback onWatchAd;
  final PremiumUpsellSheetConfig config;

  static const _premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.2115, 1.0],
    colors: [Color(0xFF9B35F4), Color(0xFFFBBF24)],
  );

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Only offer the rewarded refill while the learner has refills left today.
    var canWatchAd = config.showWatchAd;
    if (canWatchAd) {
      try {
        canWatchAd = context.watch<HomeViewModel>().canWatchHeartRefillAd;
      } catch (_) {
        canWatchAd = config.showWatchAd;
      }
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.w(24)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppSizes.h(12)),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: AppSizes.w(16)),
              child: _CloseButton(onTap: onClose, isDark: isDark),
            ),
          ),
          _SheetHeroImage(config: config),
          SizedBox(height: AppSizes.h(8)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w(24)),
            child: Text(
              config.title ?? l10n.outOfHearts,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(22),
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
                height: 1.25,
              ),
            ),
          ),
          SizedBox(height: AppSizes.h(10)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w(28)),
            child: Text(
              config.subtitle ?? l10n.outOfHeartsSub,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(14),
                fontWeight: FontWeight.w400,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.profileSubtitleColor,
                height: 1.45,
              ),
            ),
          ),
          SizedBox(height: AppSizes.h(20)),
          Text(
            config.sectionLabel ?? l10n.getMoreHearts,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.h(30)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w(20)),
            child: Column(
              children: [
                ActionOptionCard(
                  title: l10n.goUnlimited,
                  subtitle: l10n.goUnlimitedSub,
                  gradient: _premiumGradient,
                  titleColor: AppColors.white,
                  chevronColor: AppColors.white,
                  onTap: onGoUnlimited,
                  leading: ActionOptionLeadingIcon(
                    backgroundColor: isDark
                        ? AppColors.surfaceBgDarkColor
                        : AppColors.white,
                    child: SvgPicture.asset(
                      AppAssets.diamondSvg,
                      width: AppSizes.sp(22),
                    ),
                  ),
                ),
                if (canWatchAd) ...[
                  SizedBox(height: AppSizes.h(16)),
                  ActionOptionCard(
                    title: l10n.watchAd,
                    subtitle: l10n.watchAdSub,
                    backgroundColor: isDark
                        ? AppColors.surfaceBgDarkColor
                        : AppColors.white,
                    borderColor: isDark
                        ? AppColors.borderDarkColor
                        : AppColors.borderLight,
                    titleColor: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    subtitleColor: isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primaryColor,
                    chevronColor: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,

                    onTap: onWatchAd,
                    leading: ActionOptionLeadingIcon(
                      backgroundColor: isDark
                          ? AppColors.surfaceBgDarkColor
                          : const Color(0xfff7f1ff),
                      child: SvgPicture.asset(
                        AppAssets.watchAdSvg,
                        width: AppSizes.sp(24),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: AppSizes.h(16) + bottomInset),
        ],
      ),
    );
  }
}

class _SheetHeroImage extends StatelessWidget {
  const _SheetHeroImage({required this.config});

  final PremiumUpsellSheetConfig config;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final height = config.imageHeight ?? AppSizes.h(140);

    if (config.image != null) {
      return SizedBox(height: height, child: config.image);
    }

    return Image.asset(
      config.imageAsset ?? AppAssets.outOfHearthBird,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class _CloseButton extends StatelessWidget {
  final bool isDark;
  const _CloseButton({required this.onTap, required this.isDark});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Material(
      color: isDark ? AppColors.brandDarkSoftColor : AppColors.homeCardLavender,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: HapticService.wrap(onTap),
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppSizes.w(36),
          height: AppSizes.w(36),
          child: Icon(
            Icons.close_rounded,
            size: AppSizes.sp(20),
            color: isDark ? AppColors.textSecondaryDark : AppColors.iconColor,
          ),
        ),
      ),
    );
  }
}
