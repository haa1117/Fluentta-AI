import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetupOptionTile extends StatelessWidget {
  const SetupOptionTile({
    super.key,
    required this.svgIcons,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.isLocked = false,
  });

  final String svgIcons;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w(14),
          vertical: AppSizes.h(14),
        ),
        decoration: BoxDecoration(
          color:isSelected ?isDark ? Color(0xff302241) :AppColors.primaryColor.withValues(alpha: 0.1): isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.tileRadius),
          border: Border.all(
            color: isSelected ?  isDark ? AppColors.primaryDarkColor : AppColors.borderSelected : isDark ? AppColors.borderDarkColor:AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.w(44),
              height: AppSizes.w(44),
              decoration: BoxDecoration(
                color:isSelected ? isDark ?AppColors.surfaceBgDarkColor :  Colors.white : isDark ? AppColors.brandDarkSoftColor : AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.w(10)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgIcons,
                  color:isDark? AppColors.primaryDarkColor : AppColors.primaryColor,
                  width: AppSizes.iconMedium,
                  height: AppSizes.iconMedium,
                ),
              ),
            ),
            SizedBox(width: AppSizes.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.fontSubtitle,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark :  AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(2)),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.fontCaption,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isLocked)
              Icon(
                Icons.lock_rounded,
                color: AppColors.textSecondary,
                size: AppSizes.w(20),
              )
            else if (isSelected)
              Container(
                width: AppSizes.w(24),
                height: AppSizes.w(24),
                decoration:  BoxDecoration(
                  color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color:isDark ? AppColors.textPrimary : AppColors.white,
                  size: AppSizes.w(16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
