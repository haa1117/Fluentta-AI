import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

Future<bool?> showNotificationPermissionDialog(BuildContext context) {
  final l10n = context.l10n;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor:
            isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.w(25)),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(28)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.allowNotificationsTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(20),
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(10)),
              Text(
                l10n.allowNotificationsMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  height: 1.45,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              PrimaryButton(
                text: l10n.allowNotificationsAllow,
                onPressed: () => Navigator.pop(dialogContext, true),
              ),
              TextButton(
                onPressed: HapticService.wrap(() => Navigator.pop(dialogContext, false)),
                child: Text(
                  l10n.allowNotificationsLater,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
