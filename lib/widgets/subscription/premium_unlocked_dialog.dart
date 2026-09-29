import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

/// Shown right after Premium is unlocked — a real purchase, a restored
/// purchase, or (in debug builds) the Profile screen's "Enable Pro" tool.
Future<void> showPremiumUnlockedDialog(BuildContext context) {
  AppSizes.init(context);
  final l10n = context.l10n;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(24)),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w(24),
            AppSizes.h(24),
            AppSizes.w(24),
            AppSizes.h(24),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.w(28)),
            border: Border.all(
              color: isDark ? AppColors.borderDarkColor : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.premiumUnlockedBird,
                height: AppSizes.h(120),
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSizes.h(8)),
              Text(
                l10n.premiumUnlockedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(20),
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: AppSizes.h(16)),
              Text(
                l10n.premiumUnlockedMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(16),
                  fontWeight: FontWeight.w400,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              PrimaryButton(
                text: l10n.startPracticing,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
