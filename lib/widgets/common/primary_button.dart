import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppSizes.w(12));
    return SizedBox(
      width: double.infinity,
      height: AppSizes.h(60),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: isActive ? AppColors.primaryGradient : null,
          color: isActive
              ? null
              : isDark
                  ? AppColors.borderDarkColor
                  : const Color(0xFFE2D9E9),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
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
                              fontFamily: AppFonts.plusJakartaSans,
                              color: AppColors.white,
                              fontSize: AppSizes.sp(18),
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ],
                      ],
                    )
                  : Text(
                      text,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        color: AppColors.white,
                        fontSize: AppSizes.sp(18),
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
