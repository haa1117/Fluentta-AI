import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class OnboardingText extends StatelessWidget {
  const OnboardingText({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: AppSizes.fontHeadline,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: AppSizes.sp(16),
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
