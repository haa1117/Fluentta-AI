import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String btnText;
  final VoidCallback onTap;
  const TextButtonWidget({
    super.key,
    required this.btnText,
    required this.onTap
  });


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        btnText,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(15),
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
