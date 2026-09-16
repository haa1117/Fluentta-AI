import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class LanguageBanner extends StatelessWidget {
  final bool isDark;
  const LanguageBanner({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: AppSizes.bannerHeight),
      decoration: BoxDecoration(
        gradient: isDark ? null : AppColors.bannerGradient,
        color: isDark ? const Color(0xff302241) : null,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(20),
                vertical: AppSizes.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.chooseYourLanguage,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(4)),
                  Text(
                    l10n.personalizeExperience,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: AppSizes.fontCaption,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(end: AppSizes.w(8)),
            child: Image.asset(
              AppAssets.chooseLanguageBird,
              height: AppSizes.h(120),
              width: AppSizes.w(100),
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ],
      ),
    );
  }
}
