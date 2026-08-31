import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class WeeklyProgressReportScreen extends StatelessWidget {
  const WeeklyProgressReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final profile = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: 'Weekly Progress Report',
        showBackButton: true,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSizes.horizontalPadding),
        children: [
          _ReportCard(
            title: 'Streak',
            value: '${profile.streakDays} days',
            icon: Icons.local_fire_department_rounded,
          ),
          SizedBox(height: AppSizes.h(12)),
          _ReportCard(
            title: l10n.xpEarned,
            value: '${profile.xpEarned}',
            icon: Icons.star_rounded,
          ),
          SizedBox(height: AppSizes.h(12)),
          _ReportCard(
            title: l10n.lessonsStat,
            value: '${profile.lessonsCount}',
            icon: Icons.menu_book_rounded,
          ),
          SizedBox(height: AppSizes.h(12)),
          _ReportCard(
            title: l10n.wordsStat,
            value: '${profile.wordsCount}',
            icon: Icons.translate_rounded,
          ),
          SizedBox(height: AppSizes.h(12)),
          _ReportCard(
            title: l10n.correctionsStat,
            value: '${profile.correctionsCount}',
            icon: Icons.edit_note_rounded,
          ),
          SizedBox(height: AppSizes.h(12)),
          _ReportCard(
            title: l10n.dailyGoal,
            value: '${profile.dailyProgressMinutes}/${profile.dailyGoalMinutes} min',
            icon: Icons.timer_outlined,
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(15),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(15),
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
