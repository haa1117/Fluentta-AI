import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthCard extends StatelessWidget {
  final bool isDark;
  const AuthCard({super.key, required this.child, required this.isDark});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.authCardBackgroundDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.w(20)),
        border: Border.all(
          color: isDark ? AppColors.borderDarkColor : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: Offset(0, AppSizes.h(4)),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AuthHeader extends StatelessWidget {
  final bool isDark;
  final String title;
  final String subtitle;
  final String? imagePath;
  final double? imageHeight;
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.imageHeight,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (imagePath != null)
          Image.asset(
            imagePath!,
            height: imageHeight ?? AppSizes.h(100),
            fit: BoxFit.contain,
          ),
        if (imagePath != null) SizedBox(height: AppSizes.spaceMd),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.fontHeadline,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppSizes.spaceSm),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(14),
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.prefix,
    required this.actionText,
    required this.onTap,
    this.isDark = false,
    this.showTopDivider = false,
  });

  final String prefix;
  final String actionText;
  final VoidCallback onTap;
  final bool isDark;
  final bool showTopDivider;

  @override
  Widget build(BuildContext context) {
    final prefixColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    return GestureDetector(
      onTap: HapticService.wrap(onTap),
      child: Column(
        children: [
          if (showTopDivider) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: isDark
                  ? AppColors.borderDarkColor.withValues(alpha: 0.5)
                  : const Color(0x4DCFC2D7),
            ),
            SizedBox(height: AppSizes.h(25)),
          ],
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(16),
                fontWeight: FontWeight.w400,
                color: prefixColor,
              ),
              children: [
                TextSpan(text: prefix),
                TextSpan(
                  text: actionText,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSizes.sp(16),
                    color: isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primarySecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  final bool isDark;
  const OrDivider({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: isDark ? AppColors.borderDarkColor : AppColors.borderLight,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w(12)),
          child: Text(
            l10n.orLower,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(12),
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xff665D72),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: isDark ? AppColors.borderDarkColor : AppColors.borderLight,
          ),
        ),
      ],
    );
  }
}

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key, this.showBack = false, this.onBack, this.title});

  final bool showBack;
  final VoidCallback? onBack;
  final String? title;

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.h(56));

  @override
  Widget build(BuildContext context) {
    final appTitle = title ?? context.l10n.appName;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.appBarDarkBackgroundColor : AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.w(24),
            AppSizes.h(8),
            AppSizes.w(24),
            AppSizes.h(12),
          ),
          child: SizedBox(
            height: AppSizes.h(38),
            child: Row(
              children: [
                if (showBack)
                  GestureDetector(
                    onTap: HapticService.wrap(onBack ?? () => Navigator.of(context).pop()),
                    child: Container(
                      width: AppSizes.w(41),
                      height: AppSizes.h(38),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.brandDarkSoftColor
                            : AppColors.bannerGradientStart,
                        borderRadius: BorderRadius.circular(AppSizes.w(12)),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/svg/arrow_back_ios.svg',
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xff1F1B2E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(width: AppSizes.w(41)),
                Expanded(
                  child: Text(
                    appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(20),
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.primaryDarkColor
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.w(41)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({super.key, required this.imagePath, this.height});

  final String imagePath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      height: height ?? AppSizes.h(160),
      fit: BoxFit.contain,
    );
  }
}
