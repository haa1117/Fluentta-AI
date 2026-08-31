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
      height: AppSizes.bannerHeight,
      // padding: EdgeInsets.symmetric(
      //   horizontal: AppSizes.w(20),
      //   vertical: AppSizes.h(16),
      // ),
      decoration: BoxDecoration(
        gradient:isDark ? null : AppColors.bannerGradient,
        color: isDark ? Color(0xff302241):null,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:  EdgeInsets.symmetric(
                  horizontal: AppSizes.w(20),
                  vertical: AppSizes.h(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.chooseYourLanguage,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: AppSizes.fontTitle,
                      fontWeight: FontWeight.w700,
                      color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(4)),
                  Text(
                    l10n.personalizeExperience,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: AppSizes.fontCaption,
                      fontWeight: FontWeight.w400,
                      color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              // color: Colors.green,
              child: Image.asset(
                AppAssets.chooseLanguageBird,
                height: AppSizes.h(120),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
