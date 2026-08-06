import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SpeakTabScreen extends StatelessWidget {
  const SpeakTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: AppSizes.w(80),
                height: AppSizes.w(80),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic_none_rounded,
                  color: AppColors.primaryColor,
                  size: AppSizes.iconLarge,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              Text(
                'Speak',
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(24),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.spaceSm),
              Text(
                'Practice speaking with your AI tutor.\nStart a chat from the Home screen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
