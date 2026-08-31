import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:provider/provider.dart';

class EnglishBasicsCompleteScreen extends StatelessWidget {
  const EnglishBasicsCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Color(0xffF3E8FF)
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  icon:  Icon(Icons.close_rounded,
                  color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(
                      height: AppSizes.spaceXl,
                    ),
                    Image.asset(
                      'assets/images/lesson_completed_bird.png',
                      height: AppSizes.h(160),
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    Text(
                      'Lesson complete!',
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(28),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    Text(
                      'You learned ${lesson.title}.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(14),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(AppSizes.w(16)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                        border: Border.all(color: AppColors.borderDarkPrimary),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHAT YOU HAVE LEARNED TODAY',
                            style: TextStyle(
                              fontFamily: AppFonts.plusJakartaSans,
                              fontSize: AppSizes.sp(11),
                              fontWeight: FontWeight.w700,
                              color: AppColors.textTertiary,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: AppSizes.spaceMd),
                          ...lesson.completeItems.map(
                            (item) => Padding(
                              padding: EdgeInsets.only(bottom: AppSizes.spaceMd),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: AppSizes.w(10),
                                    height: AppSizes.w(10),
                                    margin: EdgeInsets.only(top: AppSizes.h(6)),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.w(12)),
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
                                            color: Color(0xff7B7487),
                                          ),
                                        ),
                                        SizedBox(height: AppSizes.h(2)),
                                        Text(
                                          item.subtitle,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFonts.plusJakartaSans,
                                            fontSize: AppSizes.sp(11),
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.learnSuccessGreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(
            //     AppSizes.horizontalPadding,
            //     AppSizes.spaceSm,
            //     AppSizes.horizontalPadding,
            //     AppSizes.spaceLg,
            //   ),
            //   child: SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: () => Navigator.of(context).pop(),
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.primaryColor,
            //         foregroundColor: AppColors.white,
            //         padding: EdgeInsets.symmetric(vertical: AppSizes.h(16)),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(AppSizes.w(28)),
            //         ),
            //       ),
            //       child: Text(
            //         'Done',
            //         style: TextStyle(
            //           fontFamily: AppFonts.plusJakartaSans,
            //           fontSize: AppSizes.sp(16),
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
