import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SecondaryTextButton extends StatelessWidget {
  const SecondaryTextButton({
    super.key,
    required this.text,
    required this.onPressed, required this.isDark,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color:isDark ? AppColors.textSecondaryDark: AppColors.textSecondary,
          fontSize: AppSizes.fontSubtitle,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
