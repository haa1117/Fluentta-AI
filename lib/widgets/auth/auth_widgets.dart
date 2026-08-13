import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.w(20)),
        border: Border.all(color: AppColors.borderLight),
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
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.imagePath,
    this.imageHeight,
  });

  final String title;
  final String subtitle;
  final String? imagePath;
  final double? imageHeight;

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
            color: AppColors.textPrimary,
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
            color: AppColors.textSecondary,
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
  });

  final String prefix;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(14),
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
          children: [
            TextSpan(
              text: prefix,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontWeight: FontWeight.w400,
                fontSize: AppSizes.sp(14),
              ),
            ),
            TextSpan(
              text: actionText,
              style: const TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderLight)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.w(12)),
          child: Text(
            l10n.orLower,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(13),
              color: const Color(0xff665D72),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderLight)),
      ],
    );
  }
}

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({
    super.key,
    this.showBack = false,
    this.onBack,
    this.title,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final String? title;

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.h(56));

  @override
  Widget build(BuildContext context) {
    final appTitle = title ?? context.l10n.appName;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.horizontalPadding,
            vertical: AppSizes.h(8),
          ),
          child: Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: onBack ?? () => Navigator.of(context).pop(),
                  child: Container(
                    width: AppSizes.w(40),
                    height: AppSizes.w(40),
                    decoration: BoxDecoration(
                      color: AppColors.bannerGradientStart,
                      borderRadius: BorderRadius.circular(AppSizes.w(10)),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: AppSizes.w(16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                )
              else
                SizedBox(width: AppSizes.w(40)),
              Expanded(
                child: Text(
                  appTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(18),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(width: AppSizes.w(40)),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthIllustration extends StatelessWidget {
  const AuthIllustration({
    super.key,
    required this.imagePath,
    this.height,
  });

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
