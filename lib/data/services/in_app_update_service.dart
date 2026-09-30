import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateService {
  InAppUpdateService._();

  static final InAppUpdateService instance = InAppUpdateService._();

  Future<void> checkAndPrompt(BuildContext context) async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }
      if (!context.mounted) return;
      await _showDialog(context);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('InAppUpdateService.check failed: $error');
      }
    }
  }

  Future<void> _showDialog(BuildContext context) async {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final shouldUpdate = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor:
              isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.w(25)),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.w(24)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.updateAvailableTitle,
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
                  l10n.updateAvailableMessage,
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
                  text: l10n.updateNow,
                  onPressed: () => Navigator.pop(dialogContext, true),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(
                    l10n.updateLater,
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

    if (shouldUpdate == true) {
      try {
        await InAppUpdate.performImmediateUpdate();
      } catch (error) {
        if (kDebugMode) {
          debugPrint('InAppUpdate performImmediateUpdate failed: $error');
        }
      }
    }
  }
}
