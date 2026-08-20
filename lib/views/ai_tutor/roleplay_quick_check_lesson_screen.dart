import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/roleplay_content_dto.dart';
import 'package:fluentta_ai/viewmodels/roleplay_quick_check_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_nav_button.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_progress_bar.dart';
import 'package:fluentta_ai/widgets/roleplay/roleplay_quiz_card.dart';
import 'package:provider/provider.dart';

class RoleplayQuickCheckLessonScreen extends StatelessWidget {
  const RoleplayQuickCheckLessonScreen({
    super.key,
    required this.lesson,
    required this.initialQuestionIndex,
    required this.cefrLevel,
    required this.onLessonCompleted,
    this.onProgressChanged,
  });

  final RoleplayQuickCheckLessonModel lesson;
  final int initialQuestionIndex;
  final String cefrLevel;
  final ValueChanged<RoleplayQuickCheckLessonModel> onLessonCompleted;
  final ValueChanged<int>? onProgressChanged;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoleplayQuickCheckLessonViewModel(
        lesson: lesson,
        initialQuestionIndex: initialQuestionIndex,
        onLessonCompleted: onLessonCompleted,
        onProgressChanged: onProgressChanged,
      ),
      child: _RoleplayQuickCheckLessonBody(lessonNumber: lesson.number),
    );
  }
}

class _RoleplayQuickCheckLessonBody extends StatelessWidget {
  const _RoleplayQuickCheckLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<RoleplayQuickCheckLessonViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: l10n.quickCheck,
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
          SizedBox(height: AppSizes.spaceXl * 2), 
          Expanded(
            child: SingleChildScrollView(
              child: RoleplayQuizCard(
                questionNumber: viewModel.currentIndex + 1,
                question: viewModel.currentQuestion,
                selectedIndex: viewModel.selectedIndex,
                answered: viewModel.answered,
                feedback: viewModel.answered && viewModel.isSelectionCorrect
                    ? viewModel.feedbackForSelection()
                    : null,
                onSelect: viewModel.selectOption,
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
                    label: l10n.previousWord,
                    icon: Icons.arrow_back_rounded,
                    isPrimary: false,
                    enabled: !viewModel.isFirstQuestion,
                    iconOnRight: false,
                    outlined: true,
                    onTap: viewModel.previousQuestion,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: LessonNavButton(
                    label: viewModel.isLastQuestion ? l10n.finish : l10n.next,
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                    enabled: viewModel.answered && viewModel.isSelectionCorrect,
                    iconOnRight: true,
                    onTap: () => viewModel.nextQuestion(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
