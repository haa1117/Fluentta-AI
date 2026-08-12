import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = context.watch<ProfileViewModel>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: Color(0xfff1e6f9)),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              AppAssets.profileBirdWithCircle,
              width: AppSizes.w(70),
              height: AppSizes.w(70),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: AppSizes.w(15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.hi,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(25),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  profile.levelLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primarySecondaryColor,
                  ),
                ),
                SizedBox(height: AppSizes.h(2)),
                Text(
                  l10n.learningWithFluenta,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    color: AppColors.profileSubtitleColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(10),
                  vertical: AppSizes.h(4),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFfFFF7ED),
                  borderRadius: BorderRadius.circular(AppSizes.w(20)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      color: const Color(0xFFEA580C),
                      size: AppSizes.sp(14),
                    ),
                    SizedBox(width: AppSizes.w(4)),
                    Text(
                      l10n.dayStreak(profile.streakDays),
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.h(8)),
              Text(
                l10n.progressLabel,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(10),
                  fontWeight: FontWeight.w700,
                  color: AppColors.profileSubtitleColor,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${profile.progressPercent}%',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(16),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
