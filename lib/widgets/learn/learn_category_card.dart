import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/learn_category_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LearnCategoryCard extends StatelessWidget {
  const LearnCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final LearnCategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.w(14)),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: AppColors.borderLight
          ),
          borderRadius: BorderRadius.circular(AppSizes.sp(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: AppSizes.w(44),
              height: AppSizes.w(44),
              // decoration: BoxDecoration(
              //   color: category.iconColor,
              //   borderRadius: BorderRadius.circular(AppSizes.w(12)),
              // ),
              child: SvgPicture.asset(
                category.svgIcon,
                // size: AppSizes.iconMedium,
              ),
            ),
            SizedBox(
              height: AppSizes.sp(20),
            ),
            // const Spacer(),
            Text(
              category.title,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(15),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(2)),
            Text(
              category.subtitle,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(11),
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
