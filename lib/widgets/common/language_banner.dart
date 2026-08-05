import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class LanguageBanner extends StatelessWidget {
  const LanguageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.bannerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(20),
        vertical: AppSizes.h(16),
      ),
      decoration: BoxDecoration(
        gradient: AppColors.bannerGradient,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Your Language',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: AppSizes.fontTitle,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  'We Personalize your learning Experience',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: AppSizes.fontCaption,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            AppAssets.splashBird,
            height: AppSizes.h(100),
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
