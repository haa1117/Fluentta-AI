import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/subscription/subscription_screen.dart';
import 'package:fluentta_ai/widgets/common/action_option_card.dart';
import 'package:fluentta_ai/widgets/common/premium_upsell_sheet_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Shared upsell bottom sheet (out-of-hearts + Pro-locked features).
Future<void> showPremiumUpsellBottomSheet(
  BuildContext context, {
  PremiumUpsellSheetConfig config = const PremiumUpsellSheetConfig(),
}) {
  AppSizes.init(context);

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: OutOfHeartsBottomSheet(
          config: config,
          onClose: () => Navigator.of(sheetContext).pop(),
          onGoUnlimited: () {
            Navigator.of(sheetContext).pop();
            SubscriptionScreen.open(context);
          },
          onWatchAd: () async {
            final l10n = sheetContext.l10n;
            await sheetContext.read<HomeViewModel>().addHearts(2);
            if (!sheetContext.mounted) return;
            Navigator.of(sheetContext).pop();
            if (context.mounted) {
              SnackbarHelper.showSuccess(context, l10n.watchAdSub);
            }
          },
        ),
      );
    },
  );
}

/// Shows the out-of-hearts bottom sheet when the user has no hearts left.
Future<void> showOutOfHeartsBottomSheet(
  BuildContext context, {
  PremiumUpsellSheetConfig config = const PremiumUpsellSheetConfig(),
}) {
  AppSizes.init(context);
  if (context.read<HomeViewModel>().hasUnlimitedHearts) {
    return Future.value();
  }

  return showPremiumUpsellBottomSheet(context, config: config);
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
    colors: [
      Color(0xFF9B35F4),
      Color(0xFFFBBF24),
    ],
  );

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
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
              child: _CloseButton(onTap: onClose),
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
                color: AppColors.textPrimary,
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
                color: AppColors.profileSubtitleColor,
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
              color: AppColors.textSecondary,
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
                    child: SvgPicture.asset(
                      AppAssets.diamondSvg,
                      width: AppSizes.sp(22),
                    ),
                  ),
                ),
                if (config.showWatchAd) ...[
                  SizedBox(height: AppSizes.h(16)),
                  ActionOptionCard(
                    title: l10n.watchAd,
                    subtitle: l10n.watchAdSub,
                    backgroundColor: AppColors.white,
                    borderColor: AppColors.borderLight,
                    titleColor: AppColors.textPrimary,
                    subtitleColor: AppColors.primaryColor,
                    chevronColor: AppColors.textSecondary,
                    onTap: onWatchAd,
                    leading: ActionOptionLeadingIcon(
                      backgroundColor: const Color(0xfff7f1ff),
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
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Material(
      color: AppColors.homeCardLavender,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: AppSizes.w(36),
          height: AppSizes.w(36),
          child: Icon(
            Icons.close_rounded,
            size: AppSizes.sp(20),
            color: AppColors.iconColor,
          ),
        ),
      ),
    );
  }
}
