import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SubscriptionAnnualPlanCard extends StatelessWidget {
  const SubscriptionAnnualPlanCard({
    super.key,
    required this.isSelected,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.perMonth,
    required this.onTap, required this.isDark,
  });

  final bool isSelected;
  final String badge;
  final String title;
  final String subtitle;
  final String price;
  final String perMonth;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            child: Ink(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                AppSizes.w(16),
                AppSizes.h(22),
                AppSizes.w(16),
                AppSizes.h(16),
              ),
              decoration: BoxDecoration(
                color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(
                  color: isSelected
                      ? isDark ? AppColors.primaryDarkColor : AppColors.primaryColor
                      : isDark ? AppColors.borderDarkColor : AppColors.borderLight,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(16),
                            fontWeight: FontWeight.w700,
                            color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(4)),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(13),
                            fontWeight: FontWeight.w600,
                            color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            price,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(20),
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.primaryDarkColor
                                  : AppColors.primaryColor,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            perMonth,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(11),
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -AppSizes.h(10),
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(12),
                vertical: AppSizes.h(4),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24),
                borderRadius: BorderRadius.circular(AppSizes.w(20)),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(12),
                  fontWeight: FontWeight.w800,
                  color:isDark ? AppColors.white : AppColors.textPrimary,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubscriptionCompactPlanCard extends StatelessWidget {
  const SubscriptionCompactPlanCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.price,
    required this.onTap,
    required this.isDark,
  });

  final bool isDark;
  final bool isSelected;
  final String title;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color: isSelected
                  ? isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryColor
                  : isDark
                      ? AppColors.borderDarkColor
                      : AppColors.borderLight,
              width: 2,
            ),
          ),
          child: Center(
            child: MediaQuery.withClampedTextScaling(
              maxScaleFactor: 1.1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      height: 1.0,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      price,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(16),
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionHeartPackCard extends StatelessWidget {
  const SubscriptionHeartPackCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.heartsLabel,
    required this.price,
    required this.onTap, required this.isDark,
  });

  final bool isSelected;
  final String title;
  final String heartsLabel;
  final String price;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Ink(
          height: AppSizes.h(132),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(6),
            vertical: AppSizes.h(10),
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color: isSelected
                  ? isDark
                      ? AppColors.primaryDarkColor
                      : AppColors.primaryColor
                  : isDark
                      ? AppColors.borderDarkColor
                      : AppColors.borderLight,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_rounded,
                color: AppColors.heartRed,
                size: AppSizes.sp(18),
              ),
              SizedBox(height: AppSizes.h(6)),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(11),
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.h(2)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  heartsLabel,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.h(2)),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  price,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
