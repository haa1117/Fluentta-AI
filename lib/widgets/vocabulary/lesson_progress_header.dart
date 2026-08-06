import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_lesson_view_model.dart';
import 'package:provider/provider.dart';

class LessonProgressHeader extends StatelessWidget {
  const LessonProgressHeader({super.key, required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VocabularyLessonViewModel>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LESSON $lessonNumber PROGRESS',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor.withValues(alpha: 0.75),
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.h(4)),
            child: LinearProgressIndicator(
              value: viewModel.lessonProgress,
              minHeight: AppSizes.h(6),
              backgroundColor: AppColors.progressTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
