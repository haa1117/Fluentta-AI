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
    required this.onTap,
  });

  final bool isSelected;
  final String badge;
  final String title;
  final String subtitle;
  final String price;
  final String perMonth;
  final VoidCallback onTap;

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
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.borderLight,
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
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(4)),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(20),
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        perMonth,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(11),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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
                  color: AppColors.textPrimary,
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
    this.extraLabel,
  });

  final bool isSelected;
  final String title;
  final String price;
  final VoidCallback onTap;
  final String? extraLabel;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 110,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.w(8),
              vertical: AppSizes.h(14),
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              border: Border.all(
                color:
                    isSelected ? AppColors.primaryColor : AppColors.borderLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppSizes.h(6)),
                Text(
                  price,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (extraLabel != null) ...[
                  SizedBox(height: AppSizes.h(2)),
                  Text(
                    extraLabel!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(10),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ],
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
    required this.onTap,
  });

  final bool isSelected;
  final String title;
  final String heartsLabel;
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
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(8),
            vertical: AppSizes.h(14),
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color:
                  isSelected ? AppColors.primaryColor : AppColors.borderLight,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: AppColors.heartRed,
                size: AppSizes.sp(22),
              ),
              SizedBox(height: AppSizes.h(8)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(11),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.h(4)),
              Text(
                heartsLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: AppSizes.h(4)),
              Text(
                price,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(15),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
