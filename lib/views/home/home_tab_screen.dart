import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:fluentta_ai/widgets/home/daily_goal_card.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/home/practice_conversing_card.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:provider/provider.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final homeViewModel = context.read<HomeViewModel>();
    final shellViewModel = context.read<MainShellViewModel>();

    return Scaffold(
      appBar: AppBarWidget(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.horizontalPadding,
          AppSizes.spaceMd,
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            // SizedBox(height: AppSizes.spaceLg),
            Text(
              'Ready to practice?',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(24),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(6)),
            Text(
              'Your English journey continues here.',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(14),
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
            const DailyGoalCard(),
            SizedBox(height: AppSizes.spaceMd),
            PracticeConversingCard(
              onStartChat: () => homeViewModel.startAiChat(
                () => shellViewModel.selectTab(MainTab.speak),
              ),
            ),
            SizedBox(height: AppSizes.spaceMd),
            const HomeBannerAd(),
            SizedBox(height: AppSizes.spaceMd),
            TodaysLessonCard(
              onResume: () => homeViewModel.resumeLesson(
                () => shellViewModel.selectTab(MainTab.learn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
