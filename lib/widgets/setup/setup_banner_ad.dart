import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SetupBannerAd extends StatelessWidget {
  const SetupBannerAd({super.key});

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
