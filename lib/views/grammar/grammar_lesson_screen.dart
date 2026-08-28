import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
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
    this.onProgressChanged,
  });

  final GrammarLessonModel lesson;
  final int initialStepIndex;
  final Future<void> Function(GrammarLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GrammarLessonViewModel(
        lesson: lesson,
        initialStepIndex: initialStepIndex,
        onLessonCompleted: onLessonCompleted,
        onProgressChanged: onProgressChanged,
        textToSpeechService: context.read<TextToSpeechService>(),
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
    final l10n = context.l10n;
    final viewModel = context.watch<GrammarLessonViewModel>();
    final step = viewModel.currentStep;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.lessonTitle(lessonNumber),
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
                  ...step.examples.asMap().entries.map(
                        (entry) => GrammarExampleTile(
                          example: entry.value,
                          exampleIndex: entry.key,
                        ),
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
                    label: l10n.previous,
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
                    label: viewModel.isLastStep ? l10n.finishLesson : l10n.next,
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
