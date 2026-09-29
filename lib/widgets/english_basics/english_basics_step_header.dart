import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class EnglishBasicsStepHeader extends StatelessWidget {
  const EnglishBasicsStepHeader({
    super.key,
    required this.label,
    required this.progress,
  });

  final String label;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.h(4)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSizes.h(8),
              backgroundColor: isDark
                  ? AppColors.brandDarkSoftColor
                  : AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
