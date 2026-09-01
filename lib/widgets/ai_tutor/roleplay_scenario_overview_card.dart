import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/roleplay_scenario_model.dart';
import 'package:fluentta_ai/widgets/ai_tutor/roleplay_progress_ring.dart';

class RoleplayScenarioOverviewCard extends StatelessWidget {
  const RoleplayScenarioOverviewCard({
    super.key,
    required this.scenario,
    required this.practiceTitle,
    required this.levelCode,
    required this.levelLabel,
    this.progress,
  });

  final RoleplayScenarioModel scenario;
  final String practiceTitle;
  final String levelCode;
  final String levelLabel;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppSizes.init(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color:isDark? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color:isDark ? AppColors.borderDarkColor :AppColors.borderDarkPrimary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (scenario.imagePath != null)
            Image.asset(
              scenario.imagePath!,
              width: AppSizes.w(82),
              height: AppSizes.w(82),
              fit: BoxFit.contain,
            ),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  practiceTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.brandDeepDarkColor : AppColors.primaryBlueColor,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: AppSizes.h(8)),
                Text(
                  levelCode,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(28),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.textPrimaryDark: AppColors.textPrimary,
                    height: 1,
                  ),
                ),
                Text(
                  levelLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w500,
                    color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          RoleplayProgressRing(progress: progress ?? scenario.progress, isDark: isDark),
        ],
      ),
    );
  }
}
