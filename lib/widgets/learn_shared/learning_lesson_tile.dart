import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/vocabulary_lesson_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LearningLessonTile extends StatelessWidget {
  const LearningLessonTile({
    super.key,
    required this.lesson,
    required this.onTap,
    this.lessonXpReward,
  });

  final LearningLessonItem lesson;
  final VoidCallback onTap;
  final int? lessonXpReward;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocked = lesson.status == LearningLessonStatus.locked;
    final isInProgress = lesson.status == LearningLessonStatus.inProgress;
    final isCompleted = lesson.status == LearningLessonStatus.completed;

    final borderRadius = BorderRadius.circular(AppSizes.cardRadius);

    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.spaceSm),
      padding: EdgeInsets.all(AppSizes.w(14)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: borderRadius,
        border: isLocked
            ? null
            : isInProgress
                ? Border.all(
                    color: isDark
                        ? AppColors.tileBorderDarkColor
                        : AppColors.primaryColor,
                    width: 1.5,
                  )
                : Border.all(
                    color: isDark
                        ? AppColors.borderDarkColor
                        : AppColors.borderDarkPrimary,
                  ),
        boxShadow: isLocked
            ? null
            : [
                BoxShadow(
                  color: (isDark
                          ? AppColors.primaryDarkColor
                          : AppColors.primaryColor)
                      .withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      foregroundDecoration: isLocked
          ? DottedDecoration(
              shape: Shape.box,
              borderRadius: borderRadius,
              color: isDark
                  ? AppColors.borderDarkColor
                  : AppColors.borderDarkPrimary,
              strokeWidth: 1.5,
              dash: const [5, 4],
            )
          : null,
      child: Row(
        children: [
          _LessonIcon(lesson: lesson, isDark: isDark),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.displayTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w700,
                    color: isLocked
                        ? (isDark
                            ? AppColors.iconColorDark
                            : AppColors.textTertiary)
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary),
                  ),
                ),
                if (isCompleted && lessonXpReward != null) ...[
                  SizedBox(height: AppSizes.h(2)),
                  Text(
                    l10n.xpEarnedCelebration(lessonXpReward!),
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(11),
                      fontWeight: FontWeight.w700,
                      color: AppColors.xpEarnedTextColor,
                    ),
                  ),
                ] else if (_progressLabel(l10n, lesson).isNotEmpty) ...[
                  SizedBox(height: AppSizes.h(2)),
                  Text(
                    _progressLabel(l10n, lesson),
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(11),
                      fontWeight: FontWeight.w500,
                      color: isCompleted
                          ? AppColors.learnSuccessGreen
                          : (isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xffD3C4DC)),
                    ),
                  ),
                ],
                if (isInProgress) ...[
                  SizedBox(height: AppSizes.spaceSm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.h(3)),
                    child: LinearProgressIndicator(
                      value: lesson.progressValue,
                      minHeight: AppSizes.h(4),
                      backgroundColor: isDark
                          ? AppColors.brandDarkSoftColor
                          : AppColors.progressTrack,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark
                            ? AppColors.primaryDarkColor
                            : AppColors.primaryBlueColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSizes.w(8)),
          _ActionButton(
            status: lesson.status,
            onTap: isLocked ? null : onTap,
            l10n: l10n,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  String _progressLabel(AppLocalizations l10n, LearningLessonItem lesson) {
    if (lesson.progressLabel.isNotEmpty) {
      return lesson.progressLabel;
    }
    return _statusLabel(l10n, lesson.status);
  }

  String _statusLabel(AppLocalizations l10n, LearningLessonStatus status) {
    return switch (status) {
      LearningLessonStatus.completed => l10n.completed,
      LearningLessonStatus.inProgress => l10n.inProgress,
      LearningLessonStatus.notStarted => '',
      LearningLessonStatus.locked => l10n.locked,
    };
  }
}

class _LessonIcon extends StatelessWidget {
  const _LessonIcon({required this.lesson, required this.isDark});

  final LearningLessonItem lesson;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.status == LearningLessonStatus.completed;
    final isLocked = lesson.status == LearningLessonStatus.locked;

    late final Color bgColor;
    late final String svgIcon;

    if (isCompleted) {
      bgColor = AppColors.learnSuccessGreen.withValues(alpha: 0.15);
      svgIcon = 'assets/svg/check.svg';
    } else if (isLocked) {
      bgColor = isDark
          ? AppColors.brandDarkSoftColor
          : AppColors.homeCardLavender;
      svgIcon = 'assets/svg/lock.svg';
    } else {
      bgColor = isDark
          ? AppColors.brandDarkSoftColor
          : AppColors.homeCardLavender;
      svgIcon = switch (lesson.iconName) {
        'travel' => 'assets/svg/today.svg',
        'chat' => 'assets/svg/lesson.svg',
        'grammar' => 'assets/svg/grammar.svg',
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
      child: Center(
        child: SvgPicture.asset(
          svgIcon,
          width: AppSizes.iconSmall,
          height: AppSizes.iconSmall,
          // colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.status,
    required this.l10n,
    required this.isDark,
    this.onTap,
  });

  final LearningLessonStatus status;
  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (status == LearningLessonStatus.completed) {
      return _pillButton(
        label: l10n.open,
        isOpenStyle: true,
        filled: false,
        enabled: true,
        onTap: onTap,
      );
    }
    if (status == LearningLessonStatus.inProgress) {
      return _pillButton(
        label: l10n.continueBtn,
        isOpenStyle: false,
        filled: true,
        enabled: true,
        onTap: onTap,
      );
    }
    if (status == LearningLessonStatus.notStarted) {
      return _pillButton(
        label: l10n.start,
        isOpenStyle: false,
        filled: false,
        enabled: true,
        onTap: onTap,
      );
    }
    return _pillButton(
      label: l10n.start,
      isOpenStyle: false,
      filled: false,
      enabled: false,
      onTap: null,
    );
  }

  Widget _pillButton({
    required String label,
    required bool isOpenStyle,
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
          color: isOpenStyle
              ? (isDark
                  ? AppColors.brandDarkSoftColor
                  : const Color(0xffF7F1FF))
              : (filled
                  ? (isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryBlueColor)
                  : (enabled
                      ? (isDark
                          ? AppColors.surfaceBgDarkColor
                          : Colors.white)
                      : (isDark
                          ? AppColors.brandDarkSoftColor
                          : const Color(0xffF7F1FF)))),
          borderRadius: BorderRadius.circular(AppSizes.w(10)),
          border: enabled
              ? Border.all(
                  color: isDark
                      ? AppColors.borderDarkColor
                      : const Color(0xffF7F1FF),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(13),
            fontWeight: FontWeight.w600,
            color: filled
                ? AppColors.white
                : (enabled
                    ? (isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primaryBlueColor)
                    : (isDark
                        ? AppColors.iconColorDark
                        : AppColors.textTertiary)),
          ),
        ),
      ),
    );
  }
}
