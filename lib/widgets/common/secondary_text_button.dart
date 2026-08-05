import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SecondaryTextButton extends StatelessWidget {
  const SecondaryTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: AppColors.textSecondary,
          fontSize: AppSizes.fontSubtitle,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
