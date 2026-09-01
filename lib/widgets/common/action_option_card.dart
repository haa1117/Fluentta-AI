import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// Reusable tappable card for bottom sheets and paywalls.
/// Supports gradient (premium) or bordered white (secondary) styles.
class ActionOptionCard extends StatelessWidget {
  const  ActionOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.onTap,
    this.gradient,
    this.backgroundColor,
    this.borderColor,
    this.titleColor = AppColors.textPrimary,
    this.subtitleColor = AppColors.primaryColor,
    this.chevronColor = AppColors.textSecondary,
    this.subtitleLines,
  });

  final String title;
  final String subtitle;
  final List<String>? subtitleLines;
  final Widget leading;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color chevronColor;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    final lines = subtitleLines ?? subtitle.split('\n');
    final isGradient = gradient != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? backgroundColor ?? AppColors.white : null,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: borderColor != null ? Border.all(color: borderColor!,width: 1.5) : null,

            // boxShadow: const [
            //   BoxShadow(
            //     color: Color(0x33630ED4), // #630ED433
            //     offset: Offset(0, 4),
            //     blurRadius: 6,
            //     spreadRadius: -4,
            //   ),
            //   BoxShadow(
            //     color: Color(0x33630ED4), // #630ED433
            //     offset: Offset(0, 10),
            //     blurRadius: 15,
            //     spreadRadius: -3,
            //   ),
            // ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(14),
            vertical: AppSizes.h(14),
          ),
          child: Row(
            children: [
              leading,
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(4)),
                    if (isGradient && lines.length > 1)
                      ...lines.map(
                        (line) => Padding(
                          padding: EdgeInsets.only(
                            bottom: line == lines.last ? 0 : AppSizes.h(2),
                          ),
                          child: Text(
                            line,
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(
                                line == lines.first ? 12 : 11,
                              ),
                              fontWeight: line == lines.first
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: titleColor.withValues(
                                alpha: line == lines.first ? 0.95 : 0.85,
                              ),
                              height: 1.3,
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(12),
                          fontWeight: FontWeight.w600,
                          color: subtitleColor,
                          height: 1.3,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: chevronColor,
                size: AppSizes.sp(24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded icon tile used inside [ActionOptionCard].
class ActionOptionLeadingIcon extends StatelessWidget {
  const ActionOptionLeadingIcon({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.white,
    this.size,
  });

  final Widget child;
  final Color backgroundColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final boxSize = size ?? AppSizes.w(45);

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.w(13)),
      ),
      child: Center(child: child),
    );
  }
}
