import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class LessonNavButton extends StatelessWidget {
  const LessonNavButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.enabled,
    required this.iconOnRight,
    required this.onTap,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool enabled;
  final bool iconOnRight;
  final VoidCallback onTap;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor =
        isDark ? AppColors.primaryDarkColor : AppColors.primaryColor;
    final activeColor = isPrimary ? accentColor : AppColors.white;
    final textColor = outlined
        ? (enabled ? accentColor : AppColors.white)
        : (enabled ? AppColors.white : AppColors.textTertiary);
    final iconColor = outlined
        ? (enabled ? accentColor : AppColors.white)
        : (enabled ? AppColors.white : AppColors.textTertiary);

    Color? backgroundColor;
    Gradient? backgroundGradient;

    if (outlined) {
      backgroundColor = enabled
          ? (isDark ? AppColors.surfaceBgDarkColor : AppColors.white)
          : (isDark
              ? AppColors.brandDarkSoftColor
              : const Color(0xffe0d5e9));
    } else if (isPrimary || enabled) {
      if (isDark) {
        backgroundColor = accentColor;
      } else {
        backgroundGradient = AppColors.primaryGradient;
      }
    } else {
      backgroundColor = isDark
          ? AppColors.brandDarkSoftColor
          : AppColors.homeCardLavender;
    }

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: AppSizes.buttonHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            gradient: backgroundGradient,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            border: outlined
                ? Border.all(
                    color: enabled ? accentColor : Colors.transparent,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!iconOnRight) ...[
                Icon(
                  icon,
                  color: outlined ? iconColor : activeColor,
                  size: AppSizes.sp(18),
                ),
                SizedBox(width: AppSizes.w(6)),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w600,
                    color: outlined
                        ? textColor
                        : (enabled ? AppColors.white : textColor),
                  ),
                ),
              ),
              if (iconOnRight) ...[
                SizedBox(width: AppSizes.w(6)),
                Icon(
                  icon,
                  color: outlined
                      ? iconColor
                      : (enabled ? AppColors.white : iconColor),
                  size: AppSizes.sp(18),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
