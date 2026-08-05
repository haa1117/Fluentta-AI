import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.loadingText,
    this.enabled = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? loadingText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && !isLoading;

    return Container(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        gradient: isActive ? AppColors.primaryGradient : null,
        color: isActive ? null : AppColors.primaryColor.withValues(alpha: 0.35),
        // boxShadow: isActive
        //     ? [
        //         BoxShadow(
        //           color: AppColors.primaryGradientStart.withValues(alpha: 0.35),
        //           blurRadius: 16,
        //           offset: Offset(0, AppSizes.h(8)),
        //         ),
        //       ]
        //     : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          onTap: isActive ? onPressed : null,
          child: Center(
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: AppSizes.w(20),
                        height: AppSizes.w(20),
                        child: const CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      if (loadingText != null) ...[
                        SizedBox(width: AppSizes.w(10)),
                        Text(
                          loadingText!,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: AppColors.white,
                            fontSize: AppSizes.fontButton,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
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
