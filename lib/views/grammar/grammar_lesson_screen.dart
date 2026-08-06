import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/grammar_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/grammar/grammar_example_tile.dart';
import 'package:fluentta_ai/widgets/grammar/grammar_quick_tip_box.dart';
import 'package:fluentta_ai/widgets/grammar/grammar_rule_card.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_nav_button.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_progress_bar.dart';
import 'package:provider/provider.dart';

class GrammarLessonScreen extends StatelessWidget {
  const GrammarLessonScreen({
    super.key,
    required this.lesson,
    required this.initialStepIndex,
    required this.onLessonCompleted,
  });

  final GrammarLessonModel lesson;
  final int initialStepIndex;
  final ValueChanged<GrammarLessonModel> onLessonCompleted;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GrammarLessonViewModel(
        lesson: lesson,
        initialStepIndex: initialStepIndex,
        onLessonCompleted: onLessonCompleted,
      ),
      child: _GrammarLessonBody(lessonNumber: lesson.number),
    );
  }
}

class _GrammarLessonBody extends StatelessWidget {
  const _GrammarLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<GrammarLessonViewModel>();
    final step = viewModel.currentStep;

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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GrammarRuleCard(step: step),
                  SizedBox(height: AppSizes.spaceMd),
                  ...step.examples.map(
                    (example) => GrammarExampleTile(example: example),
                  ),
                  SizedBox(height: AppSizes.spaceMd),
                  GrammarQuickTipBox(tip: step.quickTip),
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
                    enabled: !viewModel.isFirstStep,
                    iconOnRight: false,
                    outlined: true,
                    onTap: viewModel.previousStep,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: LessonNavButton(
                    label: viewModel.isLastStep ? 'Finish Lesson' : 'Next',
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                    enabled: true,
                    iconOnRight: true,
                    onTap: () => viewModel.nextStep(context),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: AppSizes.spaceXxl,
          )
        ],
      ),
    );
  }
}
