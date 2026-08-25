import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/widgets/english_basics/english_basics_step_header.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class EnglishBasicsSentencesScreen extends StatelessWidget {
  const EnglishBasicsSentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Today's Lesson",
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.spaceMd),
          EnglishBasicsStepHeader(label: viewModel.stepLabel, progress: 0.6),
          SizedBox(height: AppSizes.spaceLg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.sentencesTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  lesson.sentencesSubtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                0,
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
              ),
              itemCount: lesson.questions.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSizes.spaceMd),
              itemBuilder: (context, index) {
                return _SentenceQuestionCard(
                  questionNumber: index + 1,
                  question: lesson.questions[index],
                  selectedIndex: viewModel.selectionForQuestion(index),
                  answered: viewModel.isQuestionAnswered(index),
                  onSelect: (optionIndex) =>
                      viewModel.selectSentenceOption(index, optionIndex),
                  isCorrect: viewModel.isSelectionCorrect,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSizes.horizontalPadding,
              AppSizes.spaceSm,
              AppSizes.horizontalPadding,
              AppSizes.spaceLg,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.canContinueFromSentences
                    ? () => viewModel.goToDialogue()
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor:
                      AppColors.primaryColor.withValues(alpha: 0.35),
                  disabledForegroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.w(28)),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SentenceQuestionCard extends StatelessWidget {
  const _SentenceQuestionCard({
    required this.questionNumber,
    required this.question,
    required this.selectedIndex,
    required this.answered,
    required this.onSelect,
    required this.isCorrect,
  });

  final int questionNumber;
  final EnglishBasicsSentenceQuestion question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;
  final bool Function(int questionIndex, int optionIndex) isCorrect;

  @override
  Widget build(BuildContext context) {
    final displayText = selectedIndex != null
        ? question.prompt.replaceFirst(
            '________',
            question.options[selectedIndex!],
          )
        : question.prompt;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderDarkPrimary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(10),
                  vertical: AppSizes.h(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  borderRadius: BorderRadius.circular(AppSizes.w(12)),
                ),
                child: Text(
                  'Question $questionNumber',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlueColor,
                  ),
                ),
              ),
              const Spacer(),
              if (answered && selectedIndex != null)
                Icon(
                  isCorrect(questionNumber - 1, selectedIndex!)
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: isCorrect(questionNumber - 1, selectedIndex!)
                      ? AppColors.learnSuccessGreen
                      : AppColors.redColor,
                ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Text(
            displayText,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(16),
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Wrap(
            spacing: AppSizes.w(8),
            runSpacing: AppSizes.w(8),
            children: question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedIndex == index;
              final correct = isCorrect(questionNumber - 1, index);

              Color bg = AppColors.homeCardLavender;
              Color text = AppColors.primaryColor;
              if (answered && isSelected) {
                bg = AppColors.primaryColor;
                text = AppColors.white;
              } else if (answered && correct) {
                bg = AppColors.primaryColor.withValues(alpha: 0.15);
              }

              return GestureDetector(
                onTap: answered ? null : () => onSelect(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(16),
                    vertical: AppSizes.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppSizes.w(20)),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.borderDarkPrimary,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(13),
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
