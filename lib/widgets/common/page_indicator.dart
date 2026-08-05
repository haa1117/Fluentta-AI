import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: AppSizes.w(4)),
          width: isActive
              ? AppSizes.pageIndicatorActiveWidth
              : AppSizes.pageIndicatorInactiveSize,
          height: AppSizes.pageIndicatorHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.pageIndicatorHeight),
            color: isActive
                ? AppColors.primaryColor
                : AppColors.primaryColor.withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }
}
