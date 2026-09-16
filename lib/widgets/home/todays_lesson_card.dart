import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_view_model.dart';
import 'package:fluentta_ai/widgets/ads/ad_banner_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeBannerAd extends StatelessWidget {
  final double bottomPadding;
  const HomeBannerAd({
    super.key,
    this.placement = AdPlacement.homeBanner,  this.bottomPadding=0,
  });

  final AdPlacement placement;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdMobService.instance,
      builder: (context, _) {
        if (!AdMobService.instance.shouldDisplay(placement)) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding:  EdgeInsets.only(top:AppSizes.spaceMd,bottom: bottomPadding ),
          child: AdBannerWidget(
            placement: placement,
            fallbackHeight: AppSizes.h(50),
          ),
        );
      },
    );
  }
}

class TodaysLessonCard extends StatelessWidget {
  final bool isDark;
  const TodaysLessonCard({
    super.key,
    required this.onStartLesson,
    required this.isDark
  });

  final VoidCallback onStartLesson;

  @override
  Widget build(BuildContext context) {
    final basicsViewModel = context.watch<EnglishBasicsViewModel>();
    final l10n = context.l10n;

    if (basicsViewModel.isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }


    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color:isDark ? AppColors.appBarDarkBackgroundColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color:isDark ? AppColors.borderDarkColor : AppColors.borderLight
        ),
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
                      l10n.todaysLessonTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(14),
                        fontWeight: FontWeight.w600,
                        color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    Text(
                      basicsViewModel.pathTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(20),
                        fontWeight: FontWeight.w600,
                        color:isDark ? AppColors.textPrimaryDark: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: AppSizes.h(4)),
                    Text(
                      l10n.learnUsefulPhrases,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w500,
                        color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: AppSizes.w(62),
                height: AppSizes.w(62),
                decoration: BoxDecoration(
                  color:isDark? AppColors.brandDarkSoftColor : AppColors.homeCardLavender,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.hatSvgIcon,
                    color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                    width: AppSizes.iconLarge,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Row(
            children: [
              _LessonTag(label: l10n.wordsStat, isDark:isDark),
              SizedBox(width: AppSizes.w(12)),
              _LessonTag(label: l10n.sentencePractice, isDark:isDark),
              SizedBox(width: AppSizes.w(12)),
              _LessonTag(label: l10n.dialogue, isDark:isDark),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          _WeeklyProgressStrip(
            completedDays: basicsViewModel.weeklyCompletion,
            isDark: isDark,
          ),
          SizedBox(height: AppSizes.spaceMd),
          GestureDetector(
            onTap: basicsViewModel.canStartOrResume ? onStartLesson : null,
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: AppSizes.h(10),
              ),
              decoration: BoxDecoration(
                color: basicsViewModel.canStartOrResume
                    ?isDark ? AppColors.brandDarkSoftColor: AppColors.resumeButtonBg
                    : isDark ? AppColors.brandDarkSoftColor : AppColors.progressTrack,
                borderRadius: BorderRadius.circular(AppSizes.w(10)),
              ),
              child: Text(
                basicsViewModel.hasCompletedToday
                    ? l10n.completed
                    : basicsViewModel.todaysLesson?.status ==
                            LearningLessonStatus.inProgress
                        ? l10n.continueBtn
                        : l10n.startLessonButton,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w600,
                  color: basicsViewModel.canStartOrResume
                      ?isDark ? AppColors.primaryDarkColor : AppColors.primaryColor
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonTag extends StatelessWidget {
  final bool isDark;
  const _LessonTag({required this.label,required this.isDark});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.w(8),
          height: AppSizes.w(8),
          decoration:  BoxDecoration(
            color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: AppSizes.w(10)),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(12),
            fontWeight: FontWeight.w500,
            color:isDark? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Last-7-days streak strip for "Today's Lesson" — a single lesson's own
/// progress bar is only ever near-empty or full, so it says nothing useful
/// once the day is done. This shows the habit instead: which of the last 7
/// days had a lesson completed, with today called out.
class _WeeklyProgressStrip extends StatelessWidget {
  const _WeeklyProgressStrip({
    required this.completedDays,
    required this.isDark,
  });

  /// 7 entries, oldest first — index 6 is today.
  final List<bool> completedDays;
  final bool isDark;

  static const _weekdayInitials = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (i) {
        final date = today.subtract(Duration(days: 6 - i));
        final isToday = i == 6;
        final isCompleted = i < completedDays.length && completedDays[i];
        final dotColor = isCompleted
            ? (isDark ? AppColors.primaryDarkColor : AppColors.primaryColor)
            : (isDark ? AppColors.brandDarkSoftColor : const Color(0xffF3E8FF));
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.w(26),
              height: AppSizes.w(26),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(
                        color: isDark
                            ? AppColors.primaryDarkColor
                            : AppColors.primaryColor,
                        width: 1.5,
                      )
                    : null,
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: AppSizes.sp(14),
                      color: AppColors.white,
                    )
                  : null,
            ),
            SizedBox(height: AppSizes.h(4)),
            Text(
              _weekdayInitials[date.weekday - 1],
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(10),
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ],
        );
      }),
    );
  }
}
