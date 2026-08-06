import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';

class LearningPathCard extends StatelessWidget {
  const LearningPathCard({
    super.key,
    required this.pathData,
  });

  final LearningPathData pathData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderDarkPrimary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pathData.title,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(20),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(4)),
                    Text(
                      pathData.subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(13),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff4A4455),
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                AppAssets.yourLevelBird,
                width: AppSizes.w(80),
                height: AppSizes.w(80),
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${pathData.completedLessons} / ${pathData.totalLessons} lessons completed',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
              Text(
                '${pathData.progressPercent}%',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.h(4)),
            child: LinearProgressIndicator(
              value: pathData.progress,
              minHeight: AppSizes.h(6),
              backgroundColor: AppColors.progressTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlueColor,
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          Text(
            'Completed lessons stay open for review.',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontStyle: FontStyle.italic,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
