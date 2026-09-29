import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_first_frame.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/viewmodels/reading_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_lesson_tile.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_path_card.dart';
import 'package:provider/provider.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<ReadingViewModel>();

    if (viewModel.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: AppBarWidget(
          title: l10n.reading,
          showBackButton: true,
          centerTitle: true,
          showActionButton: false,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return AnalyticsFirstFrame(
      onFirstFrame: () {
        AnalyticsService.instance.logScreenView('cefr_reading');
        AnalyticsService.instance.log(AnalyticsEvents.cefrModuleViewed, {
          AnalyticsParams.cefrLevel: viewModel.analyticsCefrLevel,
          AnalyticsParams.moduleType: 'reading',
          AnalyticsParams.completedLessonCount: viewModel.completedLessonsCount,
          AnalyticsParams.moduleProgressPercent: viewModel.pathProgressPercent,
          AnalyticsParams.currentXp: viewModel.currentXp,
        });
      },
      child: Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.reading,
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSizes.horizontalPadding,
          AppSizes.spaceMd,
          AppSizes.horizontalPadding,
          AppSizes.spaceLg,
        ),
        children: [
          LearningPathCard(pathData: viewModel.pathData),
          SizedBox(height: AppSizes.spaceLg),
          ...viewModel.lessons.map(
            (lesson) => LearningLessonTile(
              lesson: lesson,
              lessonXpReward: LessonXpRewards.readingLesson,
              onTap: () => viewModel.openLesson(context, lesson),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
