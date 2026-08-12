import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/grammar_lesson_model.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_complete_layout.dart';

class GrammarLessonCompleteScreen extends StatelessWidget {
  const GrammarLessonCompleteScreen({super.key, required this.lesson});

  final GrammarLessonModel lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LessonCompleteLayout(
      title: lesson.completionTitle ?? lesson.title,
      subtitle: l10n.grammarLessonCompleted(lesson.number),
      buttonText: l10n.startNextLesson,
      onClose: () => Navigator.of(context).pop(),
      onButtonPressed: () => Navigator.of(context).pop(),
      summaryCard: lesson.completionSummary == null
          ? null
          : Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.w(16)),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(color: AppColors.borderDarkPrimary),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.learnedUseOf,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceSm),
                  Text(
                    lesson.completionSummary!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
