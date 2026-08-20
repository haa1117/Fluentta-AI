import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';

class RoleplayQuizCard extends StatelessWidget {
  const RoleplayQuizCard({
    super.key,
    required this.questionNumber,
    required this.question,
    required this.selectedIndex,
    required this.answered,
    required this.onSelect,
    this.feedback,
  });

  final int questionNumber;
  final ReadingQuestionModel question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;
  final String? feedback;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Container(
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
            Container(
              width: AppSizes.w(28),
              height: AppSizes.w(28),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '$questionNumber',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceMd),
            Text(
              question.prompt,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(16),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
            SizedBox(height: AppSizes.spaceMd),
            ...question.options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = selectedIndex == index;
              final isCorrect = index == question.correctIndex;
              final showCorrect = answered && isCorrect;

              return Padding(
                padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                child: InkWell(
                  onTap: answered ? null : () => onSelect(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(16),
                      vertical: AppSizes.h(14),
                    ),
                    decoration: BoxDecoration(
                      color: showCorrect
                          ? AppColors.primaryColor.withValues(alpha: 0.08)
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: showCorrect || isSelected
                            ? AppColors.primaryColor
                            : AppColors.borderLight,
                        width: showCorrect || isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(14),
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (showCorrect)
                          Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.learnSuccessGreen,
                            size: AppSizes.sp(20),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (feedback != null) ...[
              SizedBox(height: AppSizes.spaceSm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.w(12)),
                decoration: BoxDecoration(
                  color: AppColors.learnSuccessGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    left: BorderSide(
                      color: AppColors.learnSuccessGreen,
                      width: 3,
                    ),
                  ),
                ),
                child: Text(
                  feedback!,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w500,
                    color: AppColors.learnSuccessGreen,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
