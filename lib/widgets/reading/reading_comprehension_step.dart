import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';

class ReadingComprehensionStep extends StatelessWidget {
  const ReadingComprehensionStep({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  final ReadingQuestionModel question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.prompt,
            style: TextStyle(
              fontSize: AppSizes.sp(16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedIndex == index;
            return Padding(
              padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(16),
                    vertical: AppSizes.h(14),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor.withValues(alpha: 0.12)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: AppSizes.sp(14),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
