import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/widgets/english_basics/english_basics_step_header.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EnglishBasicsSentencesScreen extends StatelessWidget {
  const EnglishBasicsSentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
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
            padding:
                EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
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
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppSizes.spaceMd),
              itemBuilder: (context, index) {
                return _SentenceQuestionCard(
                  questionNumber: index + 1,
                  questionIndex: index,
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
          FooterWidget(
            child: PrimaryButton(text: 'Continue',  onPressed: viewModel.canContinueFromSentences
                ? () => viewModel.goToDialogue()
                : null,
              enabled: viewModel.canContinueFromSentences,

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
    required this.questionIndex,
    required this.question,
    required this.selectedIndex,
    required this.answered,
    required this.onSelect,
    required this.isCorrect,
  });

  final int questionNumber;
  final int questionIndex;
  final EnglishBasicsSentenceQuestion question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;
  final bool Function(int questionIndex, int optionIndex) isCorrect;

  @override
  Widget build(BuildContext context) {
    final questionAnswered = answered && selectedIndex != null;
    final selectionIsCorrect = questionAnswered &&
        isCorrect(questionIndex, selectedIndex!);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderDarkPrimary),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(12),
                  vertical: AppSizes.h(5),
                ),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  borderRadius: BorderRadius.circular(AppSizes.w(16)),
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
              if (questionAnswered)
                Container(
                  width: AppSizes.w(20),
                  height: AppSizes.w(20),
                  decoration: BoxDecoration(
                    // color: selectionIsCorrect
                    //     ? AppColors.learnSuccessGreen
                    //     : AppColors.redColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    selectionIsCorrect
                        ? AppAssets.correctAnswer
                        : AppAssets.wrongAnswer,
                    // color: AppColors.white,
                    width: AppSizes.sp(18),
                    height: AppSizes.sp(18),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          _SentenceWithBlank(
            prompt: question.prompt,
            selectedWord: questionAnswered
                ? question.options[selectedIndex!]
                : null,
            isCorrect: selectionIsCorrect,
            answered: questionAnswered,
          ),
          SizedBox(height: AppSizes.spaceMd),
          Wrap(
            spacing: AppSizes.w(10),
            runSpacing: AppSizes.w(10),
            children: question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedIndex == index;

              final Color bg;
              final Color textColor;
              final Color borderColor;

              if (isSelected) {
                bg = AppColors.primaryBlueColor;
                textColor = AppColors.white;
                borderColor = AppColors.primaryColor;
              } else {
                bg = AppColors.homeCardLavender;
                textColor = AppColors.textSecondary;
                borderColor = AppColors.borderDarkPrimary;
              }

              return GestureDetector(
                onTap: questionAnswered ? null : () => onSelect(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(18),
                    vertical: AppSizes.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(AppSizes.w(22)),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w600,
                      color: textColor,
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

class _SentenceWithBlank extends StatelessWidget {
  const _SentenceWithBlank({
    required this.prompt,
    required this.selectedWord,
    required this.isCorrect,
    required this.answered,
  });

  final String prompt;
  final String? selectedWord;
  final bool isCorrect;
  final bool answered;

  @override
  Widget build(BuildContext context) {
    final parts = prompt.split('________');
    final before = parts.first;
    final after = parts.length > 1 ? parts[1] : '';

    const baseStyle = TextStyle(
      fontFamily: AppFonts.plusJakartaSans,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      height: 1.5,
    );

    if (!answered || selectedWord == null) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: before,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
              fontSize: AppSizes.sp(16),
              fontFamily: AppFonts.plusJakartaSans
            )
            ),
            TextSpan(
              text: '                            ',
              style: baseStyle.copyWith(
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryBlueColor,
                decorationThickness: 2.8,

              ),
            ),
            TextSpan(text: after,
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSizes.sp(16),
                    fontFamily: AppFonts.plusJakartaSans
                )),
          ],
        ),
      );
    }

    final wordColor =
        isCorrect ? AppColors.primaryBlueColor : AppColors.redColor;

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: before,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: AppSizes.sp(16),
                  fontFamily: AppFonts.plusJakartaSans
              )
          ),
          TextSpan(
            text: selectedWord,
            style: baseStyle.copyWith(
              color: wordColor,
              decoration: TextDecoration.underline,
              decorationColor: wordColor,
              decorationThickness: 2.5,
            ),
          ),
          TextSpan(text: after,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w400,
                  fontSize: AppSizes.sp(16),
                  fontFamily: AppFonts.plusJakartaSans
              )
          ),
        ],
      ),
    );
  }
}
