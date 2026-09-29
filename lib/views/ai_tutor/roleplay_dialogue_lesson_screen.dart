import 'package:fluentta_ai/core/analytics/analytics_service.dart';
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

const String _kScreenId = 'role_play_dialogue_lesson';

class RoleplayDialogueLessonScreen extends StatefulWidget {
  const RoleplayDialogueLessonScreen({
    super.key,
    required this.lesson,
    required this.initialPhaseIndex,
    required this.onLessonCompleted,
    required this.scenarioId,
    required this.cefrLevel,
    required this.entryAction,
    this.onProgressChanged,
  });

  final RoleplayDialogueLessonModel lesson;
  final int initialPhaseIndex;
  final Future<List<String>> Function(RoleplayDialogueLessonModel, String)
      onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;
  final String scenarioId;
  final String cefrLevel;
  final String entryAction;

  @override
  State<RoleplayDialogueLessonScreen> createState() =>
      _RoleplayDialogueLessonScreenState();
}

class _RoleplayDialogueLessonScreenState
    extends State<RoleplayDialogueLessonScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView(_kScreenId);
    }
    return ChangeNotifierProvider(
      create: (context) => RoleplayDialogueLessonViewModel(
        lesson: widget.lesson,
        initialPhaseIndex: widget.initialPhaseIndex,
        onLessonCompleted: widget.onLessonCompleted,
        onProgressChanged: widget.onProgressChanged,
        textToSpeechService: context.read<TextToSpeechService>(),
        scenarioId: widget.scenarioId,
        cefrLevel: widget.cefrLevel,
        entryAction: widget.entryAction,
      ),
      child: _RoleplayDialogueLessonBody(lessonNumber: widget.lesson.number),
    );
  }
}

class _RoleplayDialogueLessonBody extends StatelessWidget {
  const _RoleplayDialogueLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<RoleplayDialogueLessonViewModel>();
    final phase = viewModel.currentPhase;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) viewModel.logExit('system_back');
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: AppBarWidget(
          title: l10n.lessonTitle(lessonNumber),
          showBackButton: true,
          centerTitle: true,
          showActionButton: false,
          onBack: () {
            viewModel.logExit('back_button');
            Navigator.of(context).pop();
          },
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
              isTextPassage: phase.isTextPassage, isDark: isDark,
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
                      ReadingFluentaTipBox(tip: phase.tip, isDark: isDark,),
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
                      enabled: viewModel.canProceed && !viewModel.isCompleting,
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
      ),
    );
  }
}
