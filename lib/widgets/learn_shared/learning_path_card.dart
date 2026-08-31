import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
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
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.borderDarkColor : AppColors.borderDarkPrimary,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.primaryDarkColor : AppColors.primaryColor)
                .withValues(alpha: 0.06),
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
                        color: isDark
                            ? AppColors.primaryDarkColor
                            : AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(4)),
                    Text(
                      pathData.subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(13),
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : const Color(0xff4A4455),
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
                l10n.lessonsCompleted(
                  pathData.completedLessons,
                  pathData.totalLessons,
                ),
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryColor,
                ),
              ),
              Text(
                '${pathData.progressPercent}%',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryColor,
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
              backgroundColor: isDark
                  ? AppColors.brandDarkSoftColor
                  : AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.primaryDarkColor : AppColors.primaryBlueColor,
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          Text(
            l10n.completedLessonsReview,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontStyle: FontStyle.italic,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
