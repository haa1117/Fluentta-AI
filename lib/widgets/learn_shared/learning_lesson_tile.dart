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
  });

  final LearningLessonItem lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isLocked = lesson.status == LearningLessonStatus.locked;
    final isInProgress = lesson.status == LearningLessonStatus.inProgress;
    final isCompleted = lesson.status == LearningLessonStatus.completed;

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
                : Border.all(color: AppColors.borderDarkPrimary),
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
                  lesson.displayTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w700,
                    color: isLocked
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                ),
                if (_progressLabel(l10n, lesson).isNotEmpty) ...[
                  SizedBox(height: AppSizes.h(2)),
                  Text(
                    _progressLabel(l10n, lesson),
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(11),
                      fontWeight: FontWeight.w500,
                      color: isCompleted
                          ? AppColors.learnSuccessGreen
                          : AppColors.textSecondary,
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
            status: lesson.status,
            onTap: isLocked ? null : onTap,
            l10n: l10n,
          ),
        ],
      ),
    );
  }

  String _progressLabel(AppLocalizations l10n, LearningLessonItem lesson) {
    if (lesson is VocabularyLessonModel) {
      final statusLabel = _statusLabel(l10n, lesson.status);
      return l10n.wordsProgress(
        lesson.wordsCompleted,
        lesson.totalWords,
        statusLabel,
      );
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
  const _LessonIcon({required this.lesson});

  final LearningLessonItem lesson;

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.status == LearningLessonStatus.completed;
    final isLocked = lesson.status == LearningLessonStatus.locked;

    late final Color bgColor;
    late final Color iconColor;
    late final String svgIcon;

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
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.status,
    required this.l10n,
    this.onTap,
  });

  final LearningLessonStatus status;
  final AppLocalizations l10n;
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
              ? const Color(0xffF7F1FF)
              : (filled
                  ? AppColors.primaryBlueColor
                  : (enabled ? Colors.white : const Color(0xffF7F1FF))),
          borderRadius: BorderRadius.circular(AppSizes.w(10)),
          border: enabled ? Border.all(color: const Color(0xffF7F1FF)) : null,
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
                    ? AppColors.primaryBlueColor
                    : AppColors.textTertiary),
          ),
        ),
      ),
    );
  }
}
