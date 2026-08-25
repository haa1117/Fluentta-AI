import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class EnglishBasicsIntroScreen extends StatelessWidget {
  const EnglishBasicsIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<EnglishBasicsFlowViewModel>();
    final lesson = viewModel.lesson;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Today's Lesson",
        showBackButton: true,
        centerTitle: true,
        showActionButton: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                AppSizes.spaceLg,
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
              ),
              child: Column(
                children: [
                  Container(
                    width: AppSizes.w(140),
                    height: AppSizes.w(140),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(100),
                      shape: BoxShape.circle,
                      color: AppColors.homeCardLavender,
                      // border: Border.all(color: AppColors.borderDarkPrimary),
                    ),
                    child: Center(
                      child: Image.asset(
                        AppAssets.todayStartLessonBird,
                        fit: BoxFit.cover,
                        width: AppSizes.w(100),
                        height: AppSizes.w(100),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  Text(
                    lesson.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(24),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceSm),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      lesson.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
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
                          'WHAT YOU WILL LEARN TODAY',
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(12),
                            fontWeight: FontWeight.w700,
                            color:Color(0xff7B7487),
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: AppSizes.spaceMd),
                        ...lesson.introItems.map(
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
                                SizedBox(width: AppSizes.w(20)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontFamily: AppFonts.plusJakartaSans,
                                          fontSize: AppSizes.sp(14),
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: AppSizes.h(2)),
                                      Text(
                                        item.subtitle,
                                        style: TextStyle(
                                          fontFamily: AppFonts.plusJakartaSans,
                                          fontSize: AppSizes.sp(12),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSizes.spaceXl,
                  ),
                  PrimaryButton(text: 'Start Lesson', onPressed: ()=>viewModel.startLesson()),
                  SizedBox(
                    height: AppSizes.spaceSm,
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
          //       onPressed: () => viewModel.startLesson(),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.primaryColor,
          //         foregroundColor: AppColors.white,
          //         padding: EdgeInsets.symmetric(vertical: AppSizes.h(16)),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(AppSizes.w(28)),
          //         ),
          //       ),
          //       child: Text(
          //         'Start Lesson',
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
    );
  }
}
