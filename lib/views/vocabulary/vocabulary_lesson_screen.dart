import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_lesson_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/vocabulary/lesson_progress_header.dart';
import 'package:fluentta_ai/widgets/vocabulary/vocabulary_word_card.dart';
import 'package:provider/provider.dart';

class VocabularyLessonScreen extends StatelessWidget {
  const VocabularyLessonScreen({
    super.key,
    required this.lesson,
    required this.initialWordIndex,
    required this.onLessonCompleted,
  });

  final VocabularyLessonModel lesson;
  final int initialWordIndex;
  final ValueChanged<VocabularyLessonModel> onLessonCompleted;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabularyLessonViewModel(
        lesson: lesson,
        initialWordIndex: initialWordIndex,
        onLessonCompleted: onLessonCompleted,
      ),
      child: _VocabularyLessonBody(lessonNumber: lesson.number),
    );
  }
}

class _VocabularyLessonBody extends StatelessWidget {
  const _VocabularyLessonBody({required this.lessonNumber});

  final int lessonNumber;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<VocabularyLessonViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Lesson $lessonNumber',
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        children: [
          SizedBox(height: AppSizes.spaceLg),
          LessonProgressHeader(lessonNumber: lessonNumber),
          SizedBox(height: AppSizes.spaceLg),
          Center(child: VocabularyWordCard()
          ),

          SizedBox(
            height: AppSizes.spaceXxl,
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
                  child: _NavWordButton(
                    label: 'Previous Word',
                    icon: Icons.arrow_back_rounded,
                    isPrimary: false,
                    enabled: !viewModel.isFirstWord,
                    iconOnRight: false,
                    onTap: viewModel.previousWord,
                  ),
                ),
                SizedBox(width: AppSizes.w(12)),
                Expanded(
                  child: _NavWordButton(
                    label: 'Next Word',
                    icon: Icons.arrow_forward_rounded,
                    isPrimary: true,
                    enabled: true,
                    iconOnRight: true,
                    onTap: () => viewModel.nextWord(context),
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

class _NavWordButton extends StatelessWidget {
  const _NavWordButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.enabled,
    required this.iconOnRight,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool enabled;
  final bool iconOnRight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: AppSizes.buttonHeight,
        decoration: BoxDecoration(
          color: isPrimary || enabled
              ? AppColors.primaryColor
              : AppColors.homeCardLavender,
          gradient:isPrimary || enabled ?  AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          // border: isPrimary
          //     ? null
          //     : Border.all(
          //         color: enabled
          //             ? AppColors.primaryColor.withValues(alpha: 0.3)
          //             : AppColors.borderLight,
          //       ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!iconOnRight) ...[
              Icon(
                icon,
                color: AppColors.white,

                // color: isPrimary
                //     ? AppColors.white
                //     : (enabled
                //         ? AppColors.primaryColor
                //         : AppColors.white),
                size: AppSizes.sp(18),
              ),
              SizedBox(width: AppSizes.w(6)),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w600,
                  color: Colors.white
                  // color: isPrimary
                  //     ? AppColors.white
                  //     : (enabled
                  //         ? AppColors.primaryColor
                  //         : AppColors.textTertiary),
                ),
              ),
            ),
            if (iconOnRight) ...[
              SizedBox(width: AppSizes.w(6)),
              Icon(
                icon,
                color: AppColors.white,
                size: AppSizes.sp(18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
