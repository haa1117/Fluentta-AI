import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/widgets/common/confetti_burst.dart';
import 'package:provider/provider.dart';

/// Today's lesson complete — Figma 781:16709 (dark) / workplace lesson completed.
class EnglishBasicsCompleteScreen extends StatelessWidget {
  const EnglishBasicsCompleteScreen({super.key});

  static const _darkSuccess = Color(0xFF65D17A);
  static const _sectionHeaderLight = Color(0xFF7B7487);

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subtitleColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const ConfettiBurst(),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: AppSizes.h(48)),
                        Image.asset(
                          AppAssets.lessonCompletedBird,
                          height: AppSizes.h(181),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: AppSizes.h(17)),
                        Text(
                          l10n.lessonCompleteTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(26),
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: titleColor,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(9)),
                        Text(
                          l10n.youLearnedLesson(lesson.title),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(16),
                            fontWeight: FontWeight.w400,
                            height: 1,
                            color: subtitleColor,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(45)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.fromLTRB(
                            AppSizes.w(24),
                            AppSizes.h(24),
                            AppSizes.w(20),
                            AppSizes.h(16),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.surfaceBgDarkColor
                                : AppColors.white,
                            borderRadius:
                                BorderRadius.circular(AppSizes.w(24)),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDarkColor
                                  : AppColors.borderLight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.whatYouHaveLearnedToday,
                                style: TextStyle(
                                  fontFamily: AppFonts.plusJakartaSans,
                                  fontSize: AppSizes.sp(14),
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : _sectionHeaderLight,
                                ),
                              ),
                              SizedBox(height: AppSizes.h(26)),
                              ...lesson.completeItems.map(
                                (item) => Padding(
                                  padding:
                                      EdgeInsets.only(bottom: AppSizes.h(24)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: AppSizes.w(14),
                                        height: AppSizes.w(14),
                                        margin: EdgeInsets.only(
                                          top: AppSizes.h(4),
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.primaryDarkColor
                                              : AppColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: AppSizes.w(36)),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppFonts.plusJakartaSans,
                                                fontSize: AppSizes.sp(14),
                                                fontWeight: FontWeight.w700,
                                                height: 1,
                                                color: titleColor,
                                              ),
                                            ),
                                            SizedBox(height: AppSizes.h(2)),
                                            Text(
                                              item.subtitle,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppFonts.plusJakartaSans,
                                                fontSize: AppSizes.sp(12),
                                                fontWeight: FontWeight.w500,
                                                height: 1,
                                                color: subtitleColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_circle_rounded,
                                        size: AppSizes.sp(19),
                                        color: isDark
                                            ? _darkSuccess
                                            : AppColors.learnSuccessGreen,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSizes.spaceLg),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: AppSizes.spaceSm,
              right: AppSizes.horizontalPadding,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
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
