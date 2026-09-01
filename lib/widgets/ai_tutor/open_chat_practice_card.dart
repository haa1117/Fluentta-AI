import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OpenChatPracticeCard extends StatelessWidget {
  const OpenChatPracticeCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppSizes.w(16)),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.w(48),
              height: AppSizes.w(48),
              // decoration: BoxDecoration(
              //   color: AppColors.white.withValues(alpha: 0.2),
              //   borderRadius: BorderRadius.circular(AppSizes.w(12)),
              // ),
              child: SvgPicture.asset(
                'assets/svg/open_chat.svg',
              ),
            ),
            SizedBox(width: AppSizes.w(14)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Open Chat Practice',
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(16),
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: AppSizes.h(4)),
                  Text(
                    'Talk about any topic with AI Tutor',
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.white,
              size: AppSizes.sp(16),
            ),
          ],
        ),
      ),
    );
  }
}
