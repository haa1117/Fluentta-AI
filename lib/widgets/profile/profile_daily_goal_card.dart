import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:provider/provider.dart';

class ProfileDailyGoalCard extends StatelessWidget {
  final bool isDark;
  const ProfileDailyGoalCard({
    super.key,
    required this.onChangeGoal, required this.isDark,
  });

  final VoidCallback onChangeGoal;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = context.watch<ProfileViewModel>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal:  AppSizes.w(20),vertical: AppSizes.h(25)),
      decoration: BoxDecoration(
        color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        // border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.dailyGoal,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(17),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onChangeGoal,
                child: Text(
                  l10n.changeGoal,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.primaryDarkColor : AppColors.primarySecondaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(12)),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: AppSizes.sp(16),
                color:isDark ? AppColors.primaryDarkColor: AppColors.primarySecondaryColor,
              ),
              SizedBox(width: AppSizes.w(6)),
              Flexible(
                child: Text(
                  l10n.minPerDay(profile.dailyGoalMinutes),
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(12)),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.minToday(
                    profile.dailyProgressMinutes,
                    profile.dailyGoalMinutes,
                  ),
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                  ),
                ),
              ),
              Text(
                '${profile.dailyGoalPercentLabel}%',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w700,
                  color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(8)),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.w(8)),
            child: LinearProgressIndicator(
              value: profile.dailyGoalPercent,
              minHeight: AppSizes.h(8),
              backgroundColor: Color(0XFFE5EEFF),
              color:isDark ? AppColors.primaryDarkColor : AppColors.primarySecondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
