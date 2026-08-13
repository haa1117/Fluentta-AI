import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/views/subscription/subscription_screen.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:provider/provider.dart';

Future<void> showOutOfHeartsDialog(BuildContext context) {
  final l10n = context.l10n;

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(24)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.homeCardLavender,
                  ),
                ),
              ),
              Image.asset(
                AppAssets.authBird,
                height: AppSizes.h(100),
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSizes.h(12)),
              Text(
                l10n.outOfHearts,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(22),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(8)),
              Text(
                l10n.outOfHeartsSub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: AppSizes.h(12)),
              Text(
                l10n.getMoreHearts,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: AppSizes.h(16)),
              _PremiumButton(
                title: l10n.goUnlimited,
                subtitle: l10n.goUnlimitedSub,
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  SubscriptionScreen.open(dialogContext);
                },
              ),
              SizedBox(height: AppSizes.h(10)),
              _WatchAdButton(
                title: l10n.watchAd,
                subtitle: l10n.watchAdSub,
                onTap: () async {
                  await dialogContext.read<HomeViewModel>().addHearts(2);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                    SnackbarHelper.showSuccess(
                      dialogContext,
                      l10n.watchAdSub,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8E2DE2), Color(0xFFF09819)],
            ),
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
          padding: EdgeInsets.all(AppSizes.w(14)),
          child: Row(
            children: [
              Container(
                width: AppSizes.w(40),
                height: AppSizes.w(40),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.w(10)),
                ),
                child: Icon(
                  Icons.diamond_rounded,
                  color: const Color(0xFFF09819),
                  size: AppSizes.sp(22),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(11),
                        color: AppColors.white.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _WatchAdButton extends StatelessWidget {
  const _WatchAdButton({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Container(
          padding: EdgeInsets.all(AppSizes.w(14)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.w(40),
                height: AppSizes.w(40),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  borderRadius: BorderRadius.circular(AppSizes.w(10)),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.primaryColor,
                  size: AppSizes.sp(24),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
