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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(12),
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.h(4)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSizes.h(6),
              backgroundColor: AppColors.progressTrack,
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
