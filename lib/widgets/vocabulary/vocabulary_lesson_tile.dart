import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VocabularyLessonTile extends StatelessWidget {
  const VocabularyLessonTile({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  final VocabularyLessonModel lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLocked = lesson.status == VocabularyLessonStatus.locked;
    final isInProgress = lesson.status == VocabularyLessonStatus.inProgress;
    final isCompleted = lesson.status == VocabularyLessonStatus.completed;

    final borderRadius = BorderRadius.circular(AppSizes.cardRadius);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.spaceSm),
      padding: EdgeInsets.all(AppSizes.w(14)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: borderRadius,
        border: isLocked
            ? null
            : isInProgress
                ? Border.all(color: AppColors.primaryColor, width: 1.5)
                : Border.all(
                    color: AppColors.borderDarkPrimary,
                  ),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      foregroundDecoration: isLocked
          ? DottedDecoration(
              shape: Shape.box,
              borderRadius: borderRadius,
              color: AppColors.borderDarkPrimary,
              strokeWidth: 1.5,
              dash: const [5, 4],
            )
          : null,
      child: Row(
        children: [
          _LessonIcon(lesson: lesson),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson ${lesson.number}: ${lesson.title}',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w700,
                    color: isLocked
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(2)),
                Text(
                  lesson.progressLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(11),
                    fontWeight: FontWeight.w500,
                    color: isCompleted
                        ? AppColors.learnSuccessGreen
                        : AppColors.textSecondary,
                  ),
                ),
                if (isInProgress) ...[
                  SizedBox(height: AppSizes.spaceSm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.h(3)),
                    child: LinearProgressIndicator(
                      value: lesson.progressValue,
                      minHeight: AppSizes.h(4),
                      backgroundColor: AppColors.progressTrack,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBlueColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSizes.w(8)),
          _ActionButton(
            lesson: lesson,
            onTap: isLocked ? null : onTap,
          ),
        ],
      ),
    );
  }
}

class _LessonIcon extends StatelessWidget {
  const _LessonIcon({required this.lesson});

  final VocabularyLessonModel lesson;

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.status == VocabularyLessonStatus.completed;
    final isLocked = lesson.status == VocabularyLessonStatus.locked;

    Color bgColor;
    Color iconColor;
    String svgIcon;

    if (isCompleted) {
      bgColor = AppColors.learnSuccessGreen.withValues(alpha: 0.15);
      iconColor = AppColors.learnSuccessGreen;
      svgIcon = 'assets/svg/check.svg';
    } else if (isLocked) {
      bgColor = AppColors.homeCardLavender;
      iconColor = AppColors.textTertiary;
      svgIcon = 'assets/svg/lock.svg';
    } else {
      bgColor = AppColors.homeCardLavender;
      iconColor = AppColors.primaryColor;
      svgIcon = switch (lesson.iconName) {
        'travel' => 'assets/svg/today.svg',
        'chat' => 'assets/svg/lesson.svg',
        _ => 'assets/svg/today.svg',
      };
    }

    return Container(
      width: AppSizes.w(44),
      height: AppSizes.w(44),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: SvgPicture.asset(svgIcon, color: iconColor, width: AppSizes.iconSmall,

      height: AppSizes.iconSmall,
      )),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.lesson, this.onTap});

  final VocabularyLessonModel lesson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final status = lesson.status;

    if (status == VocabularyLessonStatus.completed) {
      return _pillButton(
        label: 'Open',
        filled: false,
        enabled: true,
        onTap: onTap,
      );
    }
    if (status == VocabularyLessonStatus.inProgress) {
      return _pillButton(
        label: 'Continue',
        filled: true,
        enabled: true,
        onTap: onTap,
      );
    }
    if (status == VocabularyLessonStatus.notStarted) {
      return _pillButton(
        label: 'Start',
        filled: false,
        enabled: true,
        onTap: onTap,
      );
    }
    return _pillButton(
      label: 'Start',
      filled: false,
      enabled: false,
      onTap: null,
    );
  }

  Widget _pillButton({
    required String label,
    required bool filled,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w(14),
          vertical: AppSizes.h(8),
        ),
        decoration: BoxDecoration(
            color: label == 'Open'
                ? Color(0xffF7F1FF)
                : (filled
                ? AppColors.primaryBlueColor
                : (enabled ? Colors.white : const Color(0xffF7F1FF))),
          // color: filled
          //     ? AppColors.primaryBlueColor
          //     : (enabled ? Colors.white : Color(0xffF7F1FF)),
          borderRadius: BorderRadius.circular(AppSizes.w(10)),
          border: enabled ? Border.all(
            color: Color(0xffF7F1FF)
          ):null
          // border: filled
          //     ? null
          //     : Border.all(
          //         color: enabled
          //             ? Colors.transparent
          //             : AppColors.borderLight,
          //       ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(13),
            fontWeight: FontWeight.w600,
            color:  filled
                ? AppColors.white
                : (enabled ? AppColors.primaryBlueColor : AppColors.textTertiary),
          ),
        ),
      ),
    );
  }
}
