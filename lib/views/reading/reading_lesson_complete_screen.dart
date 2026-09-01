import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/data/models/reading_lesson_model.dart';
import 'package:fluentta_ai/widgets/learn_shared/lesson_complete_layout.dart';

class ReadingLessonCompleteScreen extends StatelessWidget {
  const ReadingLessonCompleteScreen({super.key, required this.lesson});

  final ReadingLessonModel lesson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return LessonCompleteLayout(
      xpEarned: LessonXpRewards.readingLesson,
      boostLessonKey: lesson.lessonId,
      subtitle: l10n.readingLessonCompleted(lesson.number),
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
                    l10n.youHaveLearned,
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
