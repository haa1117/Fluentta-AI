import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/learn_category_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LearnCategoryCard extends StatelessWidget {
  const LearnCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.isDark,
  });

  final LearnCategoryModel category;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSizes.w(14)),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
          border: Border.all(
            color: isDark ? AppColors.borderDarkColor : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(AppSizes.sp(24)),
          boxShadow: [
            BoxShadow(
              color: (isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryColor)
                  .withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: AppSizes.w(44),
              height: AppSizes.w(44),
              child: SvgPicture.asset(category.svgIcon),
            ),
            SizedBox(height: AppSizes.sp(12)),
            Text(
              category.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(15),
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(2)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      category.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(11),
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (category.xpPerLesson != null) ...[
                    SizedBox(height: AppSizes.h(6)),
                    Text(
                      l10n.roleplayXpPerLesson(category.xpPerLesson!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(11),
                        fontWeight: FontWeight.w700,
                        color: AppColors.xpEarnedTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
