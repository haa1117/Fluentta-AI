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
  });

  final String svgIcons;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w(14),
          vertical: AppSizes.h(14),
        ),
        decoration: BoxDecoration(
          color:isSelected ? AppColors.primaryColor.withValues(alpha: 0.1): AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.tileRadius),
          border: Border.all(
            color: isSelected ? AppColors.borderSelected : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.w(44),
              height: AppSizes.w(44),
              decoration: BoxDecoration(
                color:isSelected ? Colors.white : AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.w(10)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svgIcons,
                  color: AppColors.primaryColor,
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
                      color: AppColors.textPrimary,
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
            if (isSelected)
              Container(
                width: AppSizes.w(24),
                height: AppSizes.w(24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: AppSizes.w(16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
