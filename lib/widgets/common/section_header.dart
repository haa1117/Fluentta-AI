import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final bool isDark;
  const SectionHeader({super.key, required this.title,required this.isDark});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: AppSizes.fontSubtitle,
          fontWeight: FontWeight.w700,
          color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}
