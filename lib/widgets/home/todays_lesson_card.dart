import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/english_basics_view_model.dart';
import 'package:provider/provider.dart';

class HomeBannerAd extends StatelessWidget {
  const HomeBannerAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'ADVERTISEMENT',
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(10),
            fontWeight: FontWeight.w500,
            color: AppColors.textTertiary,
            letterSpacing: 0.8,
          ),
        ),
        SizedBox(height: AppSizes.spaceSm),
        Container(
          width: double.infinity,
          height: AppSizes.h(72),
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
          decoration: BoxDecoration(
            color: AppColors.adBackground,
            borderRadius: BorderRadius.circular(AppSizes.adRadius),
            border: Border.all(color: AppColors.adBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(8),
                  vertical: AppSizes.h(4),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.adBadgeBorder),
                  borderRadius: BorderRadius.circular(AppSizes.w(4)),
                ),
                child: Text(
                  'Ad',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              Text(
                'Banner Ad Placeholder',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TodaysLessonCard extends StatelessWidget {
  const TodaysLessonCard({
    super.key,
    required this.onStartLesson,
  });

  final VoidCallback onStartLesson;

  @override
  Widget build(BuildContext context) {
    final basicsViewModel = context.watch<EnglishBasicsViewModel>();

    if (basicsViewModel.isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final lessonProgress = basicsViewModel.trackProgress;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Lesson',
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    Text(
                      basicsViewModel.pathTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(4)),
                    Text(
                      'Learn useful phrases with AI correction',
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSizes.w(52),
                height: AppSizes.w(52),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.school_outlined,
                  color: AppColors.primaryColor,
                  size: AppSizes.iconMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Row(
            children: [
              _LessonTag(label: 'Words'),
              SizedBox(width: AppSizes.w(12)),
              _LessonTag(label: 'Sentence Practice'),
              SizedBox(width: AppSizes.w(12)),
              _LessonTag(label: 'Dialogue'),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.h(4)),
                  child: LinearProgressIndicator(
                    value: lessonProgress,
                    minHeight: AppSizes.h(6),
                    backgroundColor: AppColors.progressTrack,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              GestureDetector(
                onTap: basicsViewModel.canStartOrResume ? onStartLesson : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w(20),
                    vertical: AppSizes.h(10),
                  ),
                  decoration: BoxDecoration(
                    color: basicsViewModel.canStartOrResume
                        ? AppColors.resumeButtonBg
                        : AppColors.progressTrack,
                    borderRadius: BorderRadius.circular(AppSizes.w(20)),
                  ),
                  child: Text(
                    basicsViewModel.hasCompletedToday
                        ? 'Completed'
                        : basicsViewModel.actionLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(13),
                      fontWeight: FontWeight.w600,
                      color: basicsViewModel.canStartOrResume
                          ? AppColors.primaryColor
                          : AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonTag extends StatelessWidget {
  const _LessonTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.w(6),
          height: AppSizes.w(6),
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSizes.w(4)),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(11),
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
