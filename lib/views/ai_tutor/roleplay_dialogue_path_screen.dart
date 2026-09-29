import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/repositories/daily_lesson_repository.dart';
import 'package:fluentta_ai/viewmodels/roleplay_dialogue_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_lesson_tile.dart';
import 'package:fluentta_ai/widgets/learn_shared/learning_path_card.dart';
import 'package:provider/provider.dart';

const String _kScreenId = 'role_play_dialogue';

/// Analytics `lesson_state`/`entry_action` for a [LearningLessonStatus].
String _lessonStateFor(LearningLessonStatus status) => switch (status) {
      LearningLessonStatus.completed => 'completed',
      LearningLessonStatus.inProgress => 'in_progress',
      LearningLessonStatus.notStarted => 'not_started',
      LearningLessonStatus.locked => 'locked',
    };

String _entryActionFor(LearningLessonStatus status) => switch (status) {
      LearningLessonStatus.completed => 'review',
      LearningLessonStatus.inProgress => 'resume',
      _ => 'start',
    };

class RoleplayDialoguePathScreen extends StatefulWidget {
  const RoleplayDialoguePathScreen({super.key, required this.scenarioId});

  final String scenarioId;

  @override
  State<RoleplayDialoguePathScreen> createState() =>
      _RoleplayDialoguePathScreenState();
}

class _RoleplayDialoguePathScreenState
    extends State<RoleplayDialoguePathScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return ChangeNotifierProvider(
      create: (context) => RoleplayDialogueViewModel(
        widget.scenarioId,
        context.read(),
        context.read(),
        context.read(),
        context.read(),
        context.read<DailyLessonRepository>(),
      ),
      child: Consumer<RoleplayDialogueViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Scaffold(
              backgroundColor: AppColors.scaffoldBackground(context),
              appBar: AppBarWidget(
                title: l10n.dialogue,
                showBackButton: true,
                centerTitle: true,
                showActionButton: false,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (!_loggedViewed) {
            _loggedViewed = true;
            AnalyticsService.instance.logScreenView(_kScreenId);
            AnalyticsService.instance.log(
              AnalyticsEvents.rolePlayModuleViewed,
              {
                AnalyticsParams.scenarioId: widget.scenarioId,
                AnalyticsParams.cefrLevel: viewModel.cefrLevel,
                AnalyticsParams.moduleType: 'dialogue',
                AnalyticsParams.completedLessonCount:
                    viewModel.completedLessonsCount,
                AnalyticsParams.moduleProgressPercent:
                    viewModel.totalLessonsCount == 0
                        ? 0
                        : (viewModel.completedLessonsCount /
                                    viewModel.totalLessonsCount *
                                    100)
                                .round(),
              },
            );
          }

          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground(context),
            appBar: AppBarWidget(
              title: l10n.dialogue,
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
                    onTap: () {
                      _logLessonClicked(lesson, viewModel.cefrLevel);
                      viewModel.openLesson(context, lesson);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _logLessonClicked(RoleplayDialogueLessonModel lesson, String cefrLevel) {
    AnalyticsService.instance.log(AnalyticsEvents.rolePlayLessonClicked, {
      AnalyticsParams.scenarioId: widget.scenarioId,
      AnalyticsParams.cefrLevel: cefrLevel,
      AnalyticsParams.moduleType: 'dialogue',
      AnalyticsParams.lessonId: lesson.lessonId,
      AnalyticsParams.lessonNumber: lesson.number,
      AnalyticsParams.lessonState: _lessonStateFor(lesson.status),
      AnalyticsParams.entryAction: _entryActionFor(lesson.status),
      AnalyticsParams.destinationScreen: 'role_play_dialogue_lesson',
    });
  }
}
