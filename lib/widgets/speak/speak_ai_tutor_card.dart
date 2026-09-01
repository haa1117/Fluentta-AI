import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SpeakAiTutorCard extends StatelessWidget {
  const SpeakAiTutorCard({
    super.key,
    required this.livesLabel,
    required this.onStartPractice,
  });

  final String livesLabel;
  final VoidCallback onStartPractice;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.sp(20)),
        border: Border.all(color:isDark ? AppColors.borderDarkColor : AppColors.borderLight),
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
                child: Text(
                  l10n.aiPronunciationTutor,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(22),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.brandDeepDarkColor : AppColors.primarySecondaryColor,
                    height: 1.2,
                  ),
                ),
              ),
              _HeartsBadge(label: livesLabel,isDark: isDark),
            ],
          ),
          SizedBox(height: AppSizes.h(12)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiSpeakingTutorDesc,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(14),
                        color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    _StartPracticeButton(
                      label: l10n.startPractice,
                      onTap: onStartPractice, isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSizes.w(8)),
              Image.asset(
                AppAssets.aiSpeakingTutorBird,
                width: AppSizes.w(108),
                height: AppSizes.w(108),
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeartsBadge extends StatelessWidget {
  final bool isDark;
  const _HeartsBadge({required this.label, required this.isDark});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(10),
        vertical: AppSizes.h(4),
      ),
      decoration: BoxDecoration(
        color:isDark ? AppColors.brandDarkSoftColor : AppColors.homeCardLavender,
        borderRadius: BorderRadius.circular(AppSizes.w(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(13),
              fontWeight: FontWeight.w700,
              color:isDark ? AppColors.brandDeepDarkColor : AppColors.primaryBlueColor,
            ),
          ),
          SizedBox(width: AppSizes.w(4)),
          Icon(
            Icons.favorite_rounded,
            size: AppSizes.sp(14),
            color: const Color(0xFFE53935),
          ),
        ],
      ),
    );
  }
}

class _StartPracticeButton extends StatelessWidget {
  final bool isDark;
  const _StartPracticeButton({
    required this.label,
    required this.onTap, required this.isDark,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          child: Ink(
            decoration: BoxDecoration(
              gradient:isDark ? null : AppColors.primaryGradient,
              color: isDark ? Color(0xffb65dff) : null,
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w(12),
              vertical: AppSizes.h(12),
            ),
            child: Row(
              children: [
                Image.asset(
                 isDark ? AppAssets.speakBirdWithCircleDark : AppAssets.speakBirdWithCircle,
                  width: AppSizes.w(25),
                  height: AppSizes.w(25),
                  fit: BoxFit.contain,
                ),
                SizedBox(width: AppSizes.w(6)),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(13),
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.white,
                  size: AppSizes.sp(18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
