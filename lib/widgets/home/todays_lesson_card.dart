import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
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
                      'Today\'s Lesson',
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
                      'Learn useful phrases with AI correction',
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
              _LessonTag(label: 'Words', isDark:isDark),
              SizedBox(width: AppSizes.w(12)),
              _LessonTag(label: 'Sentence Practice', isDark:isDark),
              SizedBox(width: AppSizes.w(12)),
              _LessonTag(label: 'Dialogue', isDark:isDark),
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
                    backgroundColor:isDark ? AppColors.brandDarkSoftColor : Color(0xffF3E8FF),
                    valueColor:  AlwaysStoppedAnimation<Color>(
                     isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
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
                        ?isDark ? AppColors.brandDarkSoftColor: AppColors.resumeButtonBg
                        : isDark ? AppColors.brandDarkSoftColor : AppColors.progressTrack,
                    borderRadius: BorderRadius.circular(AppSizes.w(10)),
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
                          ?isDark ? AppColors.primaryDarkColor : AppColors.primaryColor
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
