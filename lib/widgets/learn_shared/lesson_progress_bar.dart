import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class LessonProgressBar extends StatelessWidget {
  const LessonProgressBar({
    super.key,
    required this.lessonNumber,
    required this.progress,
  });

  final int lessonNumber;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.lessonProgress(lessonNumber),
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(12),
              fontWeight: FontWeight.w600,
              color: (isDark ? AppColors.primaryDarkColor : AppColors.primaryColor)
                  .withValues(alpha: 0.75),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.h(4)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: AppSizes.h(6),
              backgroundColor: isDark
                  ? AppColors.brandDarkSoftColor
                  : AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
