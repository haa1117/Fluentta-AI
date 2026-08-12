import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/views/profile/delete_account_confirmation_screen.dart';
import 'package:provider/provider.dart';

Future<void> showSignOutDialog(BuildContext context) {
  final l10n = context.l10n;

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(28)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.logOutImage,
                height: AppSizes.h(100),
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSizes.h(16)),
              Text(
                l10n.signOutQuestion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(22),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(10)),
              Text(
                l10n.signOutDialogMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff665D72),
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              PrimaryButton(text: l10n.cancelBtn, onPressed: () => Navigator.of(dialogContext).pop()),
              // SizedBox(
              //   width: double.infinity,
              //   height: AppSizes.buttonHeight,
              //   child: ElevatedButton(
              //     onPressed: () => Navigator.of(dialogContext).pop(),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: AppColors.primaryColor,
              //       foregroundColor: AppColors.white,
              //       elevation: 0,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              //       ),
              //     ),
              //     child: Text(
              //       l10n.cancelBtn,
              //       style: TextStyle(
              //         fontFamily: AppFonts.plusJakartaSans,
              //         fontSize: AppSizes.sp(16),
              //         fontWeight: FontWeight.w700,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: AppSizes.h(8)),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    dialogContext.read<AuthViewModel>().signOut();
                  },
                  child: Text(
                    l10n.signOutTitle,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.redColor,
                    ),
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

Future<void> showDeleteAccountDialog(BuildContext context) {
  final l10n = context.l10n;

  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.w(28)),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppAssets.deleteAccountDialogImage,
                height: AppSizes.h(100),
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSizes.h(16)),
              Text(
                l10n.deleteAccountQuestion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(22),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(10)),
              Text(
                l10n.deleteAccountDialogMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  height: 1.45,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).push<void>(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            const DeleteAccountConfirmationScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    ),
                  ),
                  child: Text(
                    l10n.continueBtn,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(16),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(12)),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    l10n.cancelBtn,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(15),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
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
