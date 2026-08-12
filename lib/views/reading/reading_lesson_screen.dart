import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/reading_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_nav_button.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_progress_bar.dart';
import 'package:fluentta_ai/widgets/reading/reading_dialogue_bubble.dart';
import 'package:fluentta_ai/widgets/reading/reading_fluenta_tip_box.dart';
import 'package:fluentta_ai/widgets/reading/reading_phase_header.dart';
import 'package:provider/provider.dart';

class ReadingLessonScreen extends StatelessWidget {
  const ReadingLessonScreen({
    super.key,
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
  });

  final ReadingLessonModel lesson;
  final int initialPhaseIndex;
  final ValueChanged<ReadingLessonModel> onLessonCompleted;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReadingLessonViewModel(
        lesson: lesson,
        initialPhaseIndex: initialPhaseIndex,
        onLessonCompleted: onLessonCompleted,
      ),
      child: _ReadingLessonBody(lessonNumber: lesson.number),
    );
  }
}

class _ReadingLessonBody extends StatelessWidget {
  const _ReadingLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<ReadingLessonViewModel>();
    final phase = viewModel.currentPhase;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Lesson $lessonNumber',
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        children: [
          SizedBox(height: AppSizes.spaceLg),
          LessonProgressBar(
            lessonNumber: lessonNumber,
            progress: viewModel.lessonProgress,
          ),
          SizedBox(height: AppSizes.spaceLg),
          ReadingPhaseHeader(phaseTitle: phase.phaseTitle),
          SizedBox(height: AppSizes.spaceLg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...phase.lines.map(
                    (line) => ReadingDialogueBubble(line: line),
                  ),
                  SizedBox(height: AppSizes.spaceMd),
                  ReadingFluentaTipBox(tip: phase.tip),
                  SizedBox(height: AppSizes.spaceLg),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              0,
              AppSizes.horizontalPadding,
              AppSizes.spaceMd,
            ),
            child: Row(
              children: [
                Expanded(
                  child: LessonNavButton(
                    label: 'Previous',
                    icon: Icons.arrow_back_rounded,
                    isPrimary: false,
                    enabled: !viewModel.isFirstPhase,
                    iconOnRight: false,
                    outlined: true,
                    onTap: viewModel.previousPhase,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: LessonNavButton(
                    label: viewModel.isLastPhase ? 'Finish Lesson' : 'Next',
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                    enabled: true,
                    iconOnRight: true,
                    onTap: () => viewModel.nextPhase(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.spaceXxl),
        ],
      ),
    );
  }
}
