import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/english_basics_lesson_model.dart';
import 'package:fluentta_ai/viewmodels/english_basics_flow_view_model.dart';
import 'package:fluentta_ai/widgets/english_basics/english_basics_step_header.dart';
import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:provider/provider.dart';

class EnglishBasicsWordsScreen extends StatelessWidget {
  const EnglishBasicsWordsScreen({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppSizes.spaceMd),
          EnglishBasicsStepHeader(
            label: viewModel.stepLabel,
            progress: 0.3,
          ),
          SizedBox(height: AppSizes.spaceLg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.wordsTitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  lesson.wordsSubtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                0,
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
              ),
              itemCount: lesson.words.length,
              separatorBuilder: (_, __) => SizedBox(height: AppSizes.spaceMd),
              itemBuilder: (context, index) {
                return _WordCard(
                  word: lesson.words[index],
                  onSpeak: () => viewModel.speak(lesson.words[index].word),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,

              boxShadow: [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, -2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                AppSizes.spaceLg,
                AppSizes.horizontalPadding,
                AppSizes.spaceLg,
              ),
              child: PrimaryButton(text: 'Continue', onPressed: ()=>viewModel.goToSentences()),
            ),
          )
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
          //       onPressed: () => viewModel.goToSentences(),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.primaryColor,
          //         foregroundColor: AppColors.white,
          //         padding: EdgeInsets.symmetric(vertical: AppSizes.h(16)),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(AppSizes.w(28)),
          //         ),
          //       ),
          //       child: Text(
          //         'Continue',
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

class _WordCard extends StatelessWidget {
  const _WordCard({required this.word, required this.onSpeak});

  final EnglishBasicsWordModel word;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(10),
                  vertical: AppSizes.h(4),
                ),
                decoration: BoxDecoration(
                  color: AppColors.homeCardLavender,
                  borderRadius: BorderRadius.circular(AppSizes.w(12)),
                ),
                child: Text(
                  word.tag,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(12),
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryBlueColor,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onSpeak,
                icon: const Icon(
                  Icons.volume_up_outlined,
                  color: AppColors.primaryBlueColor,
                ),
              ),
            ],
          ),
          Text(
            word.word,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(28),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            word.definition,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.w(12)),
            decoration: BoxDecoration(
              color: AppColors.homeCardLavender,
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
              border: const Border(
                left: BorderSide(color: AppColors.primaryColor, width: 4),
              ),
            ),
            child: Text(
              '"${word.example}"',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(13),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Color(0xff4A4455),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
