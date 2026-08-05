import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGradientStart.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: Offset(0, AppSizes.h(8)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: AppSizes.w(24),
                    height: AppSizes.w(24),
                    child: const CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: AppColors.white,
                      fontSize: AppSizes.fontButton,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
