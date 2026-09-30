import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/confetti_burst.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

/// Shown after the lesson that finishes a CEFR level, or the whole course.
class CurriculumCompleteScreen extends StatelessWidget {
  const CurriculumCompleteScreen({
    super.key,
    required this.levelCode,
    required this.entireCourse,
  });

  final String levelCode;
  final bool entireCourse;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subtitleColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final title = entireCourse
        ? l10n.courseCompleteTitle
        : l10n.levelCompleteTitle(levelCode);
    final body = entireCourse
        ? l10n.courseCompleteBody
        : l10n.levelCompleteBody(levelCode);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const ConfettiBurst(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppAssets.lessonCompletedBird,
                          height: AppSizes.h(181),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: AppSizes.h(17)),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(26),
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                            color: titleColor,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(12)),
                        Text(
                          body,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(16),
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PrimaryButton(
                    text: l10n.continueBtn,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                ],
              ),
            ),
            Positioned(
              top: AppSizes.spaceSm,
              right: AppSizes.horizontalPadding,
              child: GestureDetector(
                onTap: HapticService.wrap(() => Navigator.of(context).pop()),
                child: Container(
                  width: AppSizes.w(40),
                  height: AppSizes.w(40),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.brandDarkSoftColor
                        : AppColors.brandLightSoftColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.iconColor,
                    size: AppSizes.sp(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
