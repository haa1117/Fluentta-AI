import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';

class VocabularyLessonCompleteScreen extends StatelessWidget {
  const VocabularyLessonCompleteScreen({
    super.key,
    required this.lessonNumber,
    required this.learnedWords,
  });

  final int lessonNumber;
  final List<String> learnedWords;

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
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: AppSizes.w(36),
                  height: AppSizes.w(36),
                  decoration: BoxDecoration(
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
                  SizedBox(height: AppSizes.spaceXl *2),
                  Image.asset(
                    AppAssets.lessonCompletedBird,
                    height: AppSizes.h(200),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  Text(
                    '${learnedWords.length} Words Learned',
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
                    'You have completed Lesson $lessonNumber \n successfully',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceLg),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSizes.w(18),
                    runSpacing: AppSizes.h(15),
                    children: learnedWords.map(_WordChip.new).toList(),
                  ),
                  SizedBox(height: AppSizes.spaceXxl),
                  // const Spacer(),
                  PrimaryButton(
                    text: 'Start Next Lesson',
                    onPressed: () => Navigator.of(context).pop(),
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

class _WordChip extends StatelessWidget {
  const _WordChip(this.word);

  final String word;

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
        border: Border.all(
          color:AppColors.chipBorderColor,
        ),
      ),
      child: Text(
        word,
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
