import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/viewmodels/roleplay_dialogue_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_nav_button.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_progress_bar.dart';
import 'package:fluentta_ai/widgets/reading/reading_dialogue_bubble.dart';
import 'package:fluentta_ai/widgets/reading/reading_fluenta_tip_box.dart';
import 'package:fluentta_ai/widgets/reading/reading_phase_header.dart';
import 'package:provider/provider.dart';

class RoleplayDialogueLessonScreen extends StatelessWidget {
  const RoleplayDialogueLessonScreen({
    super.key,
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
    this.onProgressChanged,
  });

  final RoleplayDialogueLessonModel lesson;
  final int initialPhaseIndex;
  final ValueChanged<RoleplayDialogueLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoleplayDialogueLessonViewModel(
        lesson: lesson,
        initialPhaseIndex: initialPhaseIndex,
        onLessonCompleted: onLessonCompleted,
        onProgressChanged: onProgressChanged,
        textToSpeechService: context.read<TextToSpeechService>(),
      ),
      child: _RoleplayDialogueLessonBody(lessonNumber: lesson.number),
    );
  }
}

class _RoleplayDialogueLessonBody extends StatelessWidget {
  const _RoleplayDialogueLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<RoleplayDialogueLessonViewModel>();
    final phase = viewModel.currentPhase;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
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
                  ...phase.lines.asMap().entries.map(
                        (entry) => ReadingDialogueBubble(
                          line: entry.value,
                          lineIndex: entry.key,
                          isListening:
                              viewModel.isLineListening(entry.key),
                          onListen: (ctx) => viewModel.listenLine(
                            ctx,
                            entry.value,
                            entry.key,
                          ),
                        ),
                      ),
                  if (phase.tip.isNotEmpty) ...[
                    SizedBox(height: AppSizes.spaceMd),
                    ReadingFluentaTipBox(tip: phase.tip),
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
                    label: viewModel.isLastPhase
                        ? l10n.finishLesson
                        : l10n.next,
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
