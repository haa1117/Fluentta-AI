import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AdPlaceholder extends StatelessWidget {
  const AdPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.adPlaceholderHeight,
      padding: EdgeInsets.all(AppSizes.w(12)),
      decoration: BoxDecoration(
        color: AppColors.adBackground,
        borderRadius: BorderRadius.circular(AppSizes.adRadius),
        border: Border.all(color: AppColors.adBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppSizes.w(28),
                height: AppSizes.w(28),
                decoration: const BoxDecoration(
                  color: AppColors.adPlaceholder,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: AppSizes.w(8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(6),
                  vertical: AppSizes.h(2),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.adBadgeBorder),
                  borderRadius: BorderRadius.circular(AppSizes.w(4)),
                ),
                child: Text(
                  'Ad',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: AppSizes.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _placeholderBar(width: AppSizes.w(80)),
                  SizedBox(height: AppSizes.h(4)),
                  _placeholderBar(width: AppSizes.w(50)),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceSm),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.adPlaceholder.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSizes.w(8)),
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          _placeholderBar(width: double.infinity, height: AppSizes.h(10)),
        ],
      ),
    );
  }

  Widget _placeholderBar({required double width, double? height}) {
    return Container(
      width: width,
      height: height ?? AppSizes.h(8),
      decoration: BoxDecoration(
        color: AppColors.adPlaceholder.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.w(4)),
      ),
    );
  }
}
