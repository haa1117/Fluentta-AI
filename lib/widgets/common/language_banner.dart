import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageBanner extends StatelessWidget {
  final bool isDark;
  const LanguageBanner({super.key, required this.isDark});

  static const _designWidth = 372.0;
  static const _designHeight = 185.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      height: AppSizes.bannerHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: isDark ? null : AppColors.bannerGradient,
        color: isDark ? const Color(0xff302241) : null,
        borderRadius: BorderRadius.circular(AppSizes.languageBannerRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sx = constraints.maxWidth / _designWidth;
          final sy = constraints.maxHeight / _designHeight;
          return Stack(
            children: [
              Positioned(
                left: 160 * sx,
                top: 0,
                child: Image.asset(
                  AppAssets.chooseLanguageBird,
                  width: 234 * sx,
                  height: 234 * sx,
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned(
                left: 200 * sx,
                top: 35 * sy,
                child: SvgPicture.asset(
                  isDark
                      ? AppAssets.languageHeartDark
                      : AppAssets.languageHeart,
                ),
              ),
              Positioned(
                left: 15 * sx,
                top: 36 * sy,
                width: 175 * sx,
                child: Text(
                  l10n.chooseYourLanguage,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 26 * sx,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Positioned(
                left: 15 * sx,
                top: 119 * sy,
                width: 175 * sx,
                child: Text(
                  l10n.personalizeExperience,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12 * sx,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
