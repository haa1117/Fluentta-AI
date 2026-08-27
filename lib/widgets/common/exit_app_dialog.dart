import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

/// Shows the reusable exit confirmation dialog used across the app.
Future<void> showExitAppDialog(BuildContext context) {
  final l10n = context.l10n;

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      AppSizes.init(dialogContext);

      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.w(25)),

        ),

        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(28)),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(AppSizes.w(25)),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1.0
            )

          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppAssets.exitAppBird,
                  height: AppSizes.h(120),
                  fit: BoxFit.contain,
                ),
                // SizedBox(height: AppSizes.h(5)),
                Text(
                  l10n.exitAppQuestion,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(20),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(10)),
                Text(
                  l10n.exitAppMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.h(24)),
                PrimaryButton(
                  text: l10n.keepLearning,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
                SizedBox(height: AppSizes.h(8)),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      SystemNavigator.pop();
                    },
                    child: Text(
                      l10n.exitApp,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(16),
                        fontWeight: FontWeight.w600,
                        color: AppColors.redColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
