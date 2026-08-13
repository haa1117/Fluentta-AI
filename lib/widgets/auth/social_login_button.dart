import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SocialLoginType { google, apple }

class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  final SocialLoginType type;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isGoogle = type == SocialLoginType.google;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.w(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSizes.w(12)),
        child: Container(
          width: double.infinity,
          height: AppSizes.h(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.w(12)),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isGoogle) const _GoogleIcon() else const _AppleIcon(),
              SizedBox(width: AppSizes.w(10)),
              Text(
                isGoogle ? l10n.continueWithGoogle : l10n.continueWithApple,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w(20),
      height: AppSizes.w(20),
      child: SvgPicture.asset('assets/svg/google.svg'),
    );
  }
}

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.w(20),
      height: AppSizes.w(20),
      child: SvgPicture.asset('assets/svg/apple.svg'),
    );
  }
}
