import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoleplayPracticeOptionTile extends StatelessWidget {
  const RoleplayPracticeOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconAsset,
    this.iconBackgroundColor = AppColors.primaryColor,
    this.leadingIcon,
    this.xpLabel,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? iconAsset;
  final Color iconBackgroundColor;
  final IconData? leadingIcon;
  final String? xpLabel;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Ink(
          padding: EdgeInsets.all(AppSizes.w(14)),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: AppSizes.w(44),
                    height: AppSizes.w(44),
                    // decoration: BoxDecoration(
                    //   color: iconBackgroundColor,
                    //   borderRadius: BorderRadius.circular(AppSizes.w(12)),
                    // ),
                    child: Center(
                      child: iconAsset != null
                          ? SvgPicture.asset(
                              iconAsset!,
                              width: AppSizes.w(44),
                              height: AppSizes.w(44),
                            )
                          : Icon(
                              leadingIcon ?? Icons.help_outline_rounded,
                              size: AppSizes.sp(44),
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSizes.w(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(14),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: AppSizes.h(2)),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.spaceSm,
                    ),
                    if (xpLabel != null) ...[
                      SizedBox(width: AppSizes.w(8)),
                      Text(
                        xpLabel!,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(12),
                          fontWeight: FontWeight.w700,
                          color: AppColors.xpEarnedTextColor,
                        ),
                      ),
                    ],

                  ],
                ),
              ),
              Center(
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: AppSizes.sp(22),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
