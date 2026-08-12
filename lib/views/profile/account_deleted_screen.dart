import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class AccountDeletedScreen extends StatelessWidget {
  const AccountDeletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Spacer(flex: 2),
              Image.asset(
                'assets/images/accound_deleted_successfully.png',
                height: AppSizes.h(170),
                fit: BoxFit.contain,
              ),
              SizedBox(height: AppSizes.h(5)),
              Text(
                l10n.accountDeleted,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(28),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  l10n.accountDeletedMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(25)),
              Text(
                '"${l10n.sorryToSeeYouGo}"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(16),

                  color: AppColors.textPrimary,
                ),
              ),

              SizedBox(
                height: AppSizes.sp(40),
              ),
              // const Spacer(flex: 3),
              PrimaryButton(
                text: l10n.done,
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: AppSizes.h(30)),
              Text(
                l10n.createAccountAnytime,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  color: Color(0xff665D72),
                ),
              ),
              SizedBox(height: AppSizes.h(32)),
            ],
          ),
        ),
      ),
    );
  }
}
