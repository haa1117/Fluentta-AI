import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRect(
                child: Image.asset(
                  AppAssets.accountCreated,
                  height: AppSizes.h(280),
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              Text(
                l10n.accountCreatedTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(28),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceSm / 2),
              Text(
                l10n.accountCreatedSafeDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSizes.spaceXl),
              PrimaryButton(
                text: l10n.continueBtn,
                onPressed: onContinue,
              ),
              SizedBox(height: AppSizes.spaceXxl),
            ],
          ),
        ),
      ),
    );
  }
}
