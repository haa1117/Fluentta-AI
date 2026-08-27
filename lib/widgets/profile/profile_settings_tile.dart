import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.svgIcon,
    this.iconColor,
    this.titleColor,
    this.trailing,
    this.showChevron = true,
    this.onTap,
    this.isDestructive = false,
  });

  final String title;
  final String? subtitle;
  final String? svgIcon;
  final Color? iconColor;
  final Color? titleColor;
  final Widget? trailing;
  final bool showChevron;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = titleColor ??
        (isDestructive ? Color(0xffDC2626) : AppColors.textPrimary);
    final effectiveIconColor =
        iconColor ?? (isDestructive ? Color(0xffDC2626) : AppColors.primaryColor);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(16),
            vertical: AppSizes.h(14),
          ),
          child: Row(
            children: [
              if (svgIcon != null) ...[
                SvgPicture.asset(
                  svgIcon!,
                  width: AppSizes.sp(20),
                  height: AppSizes.sp(20),

                ),
                SizedBox(width: AppSizes.w(12)),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(16),
                        fontWeight: FontWeight.w600,
                        color: effectiveTitleColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: AppSizes.h(2)),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.profileSubtitleColor,
                  size: AppSizes.sp(22),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSettingsGroup extends StatelessWidget {
  const ProfileSettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        // border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.borderLight.withValues(alpha: 0.2),
                // indent: AppSizes.w(16),
                // endIndent: AppSizes.w(16),
              ),
          ],
        ],
      ),
    );
  }
}
