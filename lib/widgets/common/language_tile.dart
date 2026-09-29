import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.flagAsset,
    required this.languageName,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    required this.isDark,
  });

  final String flagAsset;
  final String languageName;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.w(16),
          vertical: AppSizes.h(14),
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.tileBackgroundDarkColor : AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.tileRadius),
          border: Border.all(
            color: isSelected
                ? AppColors.borderSelected
                : isDark
                    ? AppColors.borderDarkColor
                    : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _CircularFlag(
              asset: flagAsset,
              size: AppSizes.flagSize,
              cropFromStart: flagAsset == AppAssets.flagEnglish,
            ),
            SizedBox(width: AppSizes.w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: AppSizes.fontSubtitle,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: AppSizes.h(2)),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: AppSizes.fontCaption,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _RadioIndicator(
              isSelected: isSelected,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularFlag extends StatelessWidget {
  const _CircularFlag({
    required this.asset,
    required this.size,
    this.cropFromStart = false,
  });

  final String asset;
  final double size;
  final bool cropFromStart;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: cropFromStart
            ? OverflowBox(
                maxWidth: size * 1.9,
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  asset,
                  width: size * 1.9,
                  height: size,
                  fit: BoxFit.fill,
                  alignment: Alignment.centerLeft,
                ),
              )
            : SvgPicture.asset(
                asset,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool isDark;
  const _RadioIndicator({required this.isSelected, required this.isDark});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.radioSize,
      height: AppSizes.radioSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : isDark
                  ? AppColors.borderDarkColor
                  : AppColors.radioUnselected,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: AppSizes.w(12),
                height: AppSizes.w(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}
