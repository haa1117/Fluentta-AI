import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = context.watch<ProfileViewModel>();

    final cards = [
      _StatCard(
        svgIcon: 'assets/svg/stats_star.svg',

        value: '${profile.xpEarned}',
        label: l10n.xpEarned,
      ),
      _StatCard(
        svgIcon: 'assets/svg/stats_language_icon.svg',

        value: '${profile.wordsCount}',
        label: l10n.wordsStat,
      ),
      _StatCard(
        svgIcon: 'assets/svg/stats_book_icon.svg',

        value: '${profile.lessonsCount}',
        label: l10n.lessonsStat,
      ),
      _StatCard(
        svgIcon: 'assets/svg/stats_check.svg',

        value: '${profile.correctionsCount}',
        label: l10n.correctionsStat,
      ),
    ];

    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[0]),
              SizedBox(width: AppSizes.w(10)),
              Expanded(child: cards[1]),
            ],
          ),
        ),
        SizedBox(height: AppSizes.h(10)),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: cards[2]),
              SizedBox(width: AppSizes.w(10)),
              Expanded(child: cards[3]),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.svgIcon,
    required this.value,
    required this.label,
  });

  final String svgIcon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(14)),
      decoration: BoxDecoration(
        color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color:isDark ? AppColors.borderDarkColor : AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SvgPicture.asset(svgIcon,  width: AppSizes.sp(38),
            height: AppSizes.sp(38),
            ),
          ),
          SizedBox(width: AppSizes.h(15)),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(22),
                fontWeight: FontWeight.w700,
                color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(2)),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(12),
                color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                fontWeight: FontWeight.w400
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )
        ],
      ),
    );
  }
}
