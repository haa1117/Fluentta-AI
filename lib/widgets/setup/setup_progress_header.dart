import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SetupProgressHeader extends StatelessWidget {
  const SetupProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.subtitle, required this.isDark,
  });

  final int currentStep;
  final int totalSteps;
  final String title;
  final String subtitle;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP $currentStep OF $totalSteps',
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(12),
            fontWeight: FontWeight.w400,
            color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: AppSizes.spaceSm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.h(4)),
          child: LinearProgressIndicator(
            value: progress,

            minHeight: AppSizes.h(6),
            backgroundColor:isDark ? AppColors.brandDarkSoftColor: Color(0xffF3E8FF),
            valueColor:  AlwaysStoppedAnimation<Color>(
             isDark ? AppColors.primaryDarkColor: AppColors.primaryColor,
            ),
          ),
        ),
        SizedBox(height: AppSizes.spaceLg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(24),
                      fontWeight: FontWeight.w700,
                      color:isDark ? AppColors.textPrimaryDark: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceSm),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w400,
                      color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSizes.w(8)),
            Image.asset(
              AppAssets.birdWithMessage,
              width: AppSizes.w(110),
              height: AppSizes.w(110),
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
}
