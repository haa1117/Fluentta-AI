import 'package:fluentta_ai/core/haptics/haptic_service.dart';
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
                        fontSize: AppSizes.sp(16),
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
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
                width: AppSizes.w(72),
                height: AppSizes.w(72),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkScaffoldBackgroundColor
                      : AppColors.homeCardLavender,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.hatSvgIcon,
                    colorFilter: ColorFilter.mode(
                      isDark
                          ? AppColors.primaryDarkColor
                          : AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                    width: AppSizes.w(44),
                    height: AppSizes.w(44),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: LinearProgressIndicator(
                    value: basicsViewModel.todayLessonProgress,
                    minHeight: AppSizes.h(6),
                    backgroundColor: isDark
                        ? AppColors.darkScaffoldBackgroundColor
                        : AppColors.brandLightSoftColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark
                          ? AppColors.primaryDarkColor
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              GestureDetector(
                onTap: HapticService.wrap(basicsViewModel.canStartOrResume ? onStartLesson : null),
                child: Container(
                  width: AppSizes.w(122),
                  height: AppSizes.h(36),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.brandDeepDarkColor
                        : AppColors.brandLightSoftColor,
                    borderRadius: BorderRadius.circular(AppSizes.w(7)),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          basicsViewModel.hasCompletedToday
                              ? l10n.completed
                              : basicsViewModel.todaysLesson?.status ==
                                      LearningLessonStatus.inProgress
                                  ? l10n.resumeLessonButton
                                  : l10n.startLessonButton,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            fontWeight: FontWeight.w700,
                            color: basicsViewModel.canStartOrResume
                                ? (isDark
                                    ? AppColors.white
                                    : AppColors.primaryColor)
                                : AppColors.textTertiary,
                          ),
                        ),
                        if (basicsViewModel.canStartOrResume) ...[
                          SizedBox(width: AppSizes.w(4)),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: AppSizes.sp(16),
                            color: isDark
                                ? AppColors.white
                                : AppColors.primaryColor,
                          ),
                        ],
                      ],
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
