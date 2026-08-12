import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfilePremiumCard extends StatelessWidget {
  const ProfilePremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profile = context.watch<ProfileViewModel>();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(

        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Stack(
        children: [
          Positioned(
            right: AppSizes.w(8),
            top: 0,
            child: SvgPicture.asset(
              'assets/svg/Icon.svg',
              // color: AppColors.white.withValues(alpha: 0.35),
              width: AppSizes.sp(35),
              height: AppSizes.sp(35),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.freePlan,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(20),
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: AppSizes.h(4)),
              Text(
                l10n.heartsDaily(profile.lives),
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
              SizedBox(height: AppSizes.h(8)),
              Text(
                l10n.upgradePremiumDesc,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
              SizedBox(height: AppSizes.h(16)),
              Center(
                child: SizedBox(
                  width: AppSizes.screenWidth,
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                      onTap: () =>
                          SnackbarHelper.showSuccess(context, l10n.upgradeComingSoon),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.w(24),
                          vertical: AppSizes.h(12),
                        ),
                        child: Center(
                          child: Text(
                            l10n.upgradeToPremium,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(15),
                              fontWeight: FontWeight.w700,
                              color: AppColors.primarySecondaryColor,
                            ),
                          ),
                        ),
                      ),
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
