import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class LessonCompleteLayout extends StatelessWidget {
  const LessonCompleteLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onClose,
    required this.onButtonPressed,
    this.summaryCard,
    this.chips,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onClose;
  final VoidCallback onButtonPressed;
  final Widget? summaryCard;
  final List<Widget>? chips;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: AppSizes.spaceSm,
              right: AppSizes.horizontalPadding,
              child: GestureDetector(
                onTap: onClose,
                child: Container(
                  width: AppSizes.w(36),
                  height: AppSizes.w(36),
                  decoration: const BoxDecoration(
                    color: AppColors.homeCardLavender,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.iconColor,
                    size: AppSizes.sp(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: AppSizes.spaceXl * 2),
                  Image.asset(
                    AppAssets.lessonCompletedBird,
                    height: AppSizes.h(200),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(28),
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceSm),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(15),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  if (summaryCard != null) summaryCard!,
                  if (chips != null)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSizes.w(18),
                      runSpacing: AppSizes.h(15),
                      children: chips!,
                    ),
                  SizedBox(height: AppSizes.spaceXxl),
                  PrimaryButton(
                    text: buttonText,
                    onPressed: onButtonPressed,
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCompleteChip extends StatelessWidget {
  const LessonCompleteChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(16),
        vertical: AppSizes.h(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.chipBackgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.w(20)),
        border: Border.all(color: AppColors.chipBorderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(15),
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlueColor,
        ),
      ),
    );
  }
}
