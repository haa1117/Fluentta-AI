import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/viewmodels/reading_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_nav_button.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_progress_bar.dart';
import 'package:fluentta_ai/widgets/reading/reading_comprehension_step.dart';
import 'package:fluentta_ai/widgets/reading/reading_dialogue_bubble.dart';
import 'package:fluentta_ai/widgets/reading/reading_fluenta_tip_box.dart';
import 'package:fluentta_ai/widgets/reading/reading_phase_header.dart';
import 'package:fluentta_ai/widgets/reading/reading_text_passage.dart';
import 'package:provider/provider.dart';

class ReadingLessonScreen extends StatelessWidget {
  const ReadingLessonScreen({
    super.key,
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
    this.onProgressChanged,
  });

  final ReadingLessonModel lesson;
  final int initialPhaseIndex;
  final Future<void> Function(ReadingLessonModel) onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReadingLessonViewModel(
        lesson: lesson,
        initialPhaseIndex: initialPhaseIndex,
        onLessonCompleted: onLessonCompleted,
        onProgressChanged: onProgressChanged,
        textToSpeechService: context.read<TextToSpeechService>(),
        progressSyncService: context.read<ProgressSyncService>(),
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
    final l10n = context.l10n;
    final viewModel = context.watch<ReadingLessonViewModel>();
    final phase = viewModel.currentPhase;

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
          ReadingPhaseHeader(
            phaseTitle: phase.phaseTitle,
            dialoguePartNumber: phase.dialoguePartNumber,
            isTextPassage: phase.isTextPassage,
          ),
          SizedBox(height: AppSizes.spaceLg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (phase.isQuestionPhase && phase.question != null)
                    ReadingComprehensionStep(
                      question: phase.question!,
                      selectedIndex: viewModel.selectedOptionIndex,
                      onSelect: viewModel.selectOption,
                    )
                  else if (phase.isTextPassage) ...[
                    ReadingTextPassage(
                      text: phase.lines.map((line) => line.text).join(' '),
                    ),
                    if (phase.tip.isNotEmpty) ...[
                      SizedBox(height: AppSizes.spaceMd),
                      ReadingFluentaTipBox(tip: phase.tip),
                    ],
                  ] else ...[
                    ...phase.lines.asMap().entries.map(
                          (entry) => ReadingDialogueBubble(
                            line: entry.value,
                            lineIndex: entry.key,
                          ),
                        ),
                    if (phase.tip.isNotEmpty) ...[
                      SizedBox(height: AppSizes.spaceMd),
                      ReadingFluentaTipBox(tip: phase.tip),
                    ],
                  ],
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
                    enabled: !viewModel.isFirstPhase,
                    iconOnRight: false,
                    outlined: true,
                    onTap: viewModel.previousPhase,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: LessonNavButton(
                    label: viewModel.isLastPhase ? l10n.finishLesson : l10n.next,
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                    enabled: viewModel.canProceed,
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
