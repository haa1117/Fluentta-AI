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
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EnglishBasicsSentencesScreen extends StatelessWidget {
  const EnglishBasicsSentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AppBarWidget(
        title: l10n.todaysLessonTitle,
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.spaceMd),
          EnglishBasicsStepHeader(label: viewModel.stepLabelFor(l10n), progress: 0.6),
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
                    fontSize: AppSizes.sp(26),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(9)),
                Text(
                  lesson.sentencesSubtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
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
                  questionLabel: l10n.sentenceQuestionNumber(index + 1),
                );
              },
            ),
          ),
          FooterWidget(
            child: PrimaryButton(text: l10n.continueBtn,  onPressed: viewModel.canContinueFromSentences
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
    required this.questionLabel,
  });

  final int questionNumber;
  final int questionIndex;
  final EnglishBasicsSentenceQuestion question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;
  final bool Function(int questionIndex, int optionIndex) isCorrect;
  final String questionLabel;

  @override
  Widget build(BuildContext context) {
    final questionAnswered = answered && selectedIndex != null;
    final selectionIsCorrect = questionAnswered &&
        isCorrect(questionIndex, selectedIndex!);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.surfaceBgDarkColor : AppColors.white;
    final cardBorder =
        isDark ? AppColors.borderDarkColor : AppColors.borderLight;
    final titleColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(25)),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            blurRadius: 10,
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
                  vertical: AppSizes.h(4),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0x1AC084FC)
                      : AppColors.brandLightSoftColor,
                  borderRadius: BorderRadius.circular(AppSizes.w(16)),
                ),
                child: Text(
                  questionLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primaryBlueColor,
                  ),
                ),
              ),
              const Spacer(),
              if (questionAnswered)
                SvgPicture.asset(
                  selectionIsCorrect
                      ? AppAssets.correctAnswer
                      : AppAssets.wrongAnswer,
                  width: AppSizes.sp(20),
                  height: AppSizes.sp(20),
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
            textColor: titleColor,
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
                bg = isDark
                    ? AppColors.brandDarkSoftColor
                    : AppColors.brandLightSoftColor;
                textColor = isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary;
                borderColor =
                    isDark ? AppColors.borderDarkColor : AppColors.borderLight;
              }

              // Locked only once this question's correct word has been
              // found — a wrong pick stays tappable so the learner can retry.
              final locked = questionAnswered && selectionIsCorrect;
              return GestureDetector(
                onTap: locked ? null : () => onSelect(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(24),
                    vertical: AppSizes.h(9),
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
                      fontWeight: FontWeight.w700,
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
    required this.textColor,
  });

  final String prompt;
  final String? selectedWord;
  final bool isCorrect;
  final bool answered;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final parts = prompt.split('________');
    final before = parts.first;
    final after = parts.length > 1 ? parts[1] : '';

    final baseStyle = TextStyle(
      fontFamily: AppFonts.plusJakartaSans,
      fontSize: AppSizes.sp(18),
      fontWeight: FontWeight.w400,
      color: textColor,
      height: 1.5,
    );

    if (!answered || selectedWord == null) {
      return RichText(
        text: TextSpan(
          style: baseStyle,
          children: [
            TextSpan(text: before),
            TextSpan(
              text: '                            ',
              style: baseStyle.copyWith(
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryBlueColor,
                decorationThickness: 2.8,
              ),
            ),
            TextSpan(text: after),
          ],
        ),
      );
    }

    final wordColor =
        isCorrect ? AppColors.primaryColor : AppColors.redColor;

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: before),
          TextSpan(
            text: selectedWord,
            style: baseStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: wordColor,
              decoration: TextDecoration.underline,
              decorationColor: wordColor,
              decorationThickness: 2.5,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
