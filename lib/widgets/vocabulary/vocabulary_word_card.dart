import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_lesson_view_model.dart';
import 'package:provider/provider.dart';

class VocabularyWordCard extends StatelessWidget {
  const VocabularyWordCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VocabularyLessonViewModel>();
    final word = viewModel.currentWord;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Word .${viewModel.currentWordIndex + 1}',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Text(
            word.word,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(36),
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            word.phonetic,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppSizes.spaceLg),
          Text(
            'MEANING',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
              letterSpacing: 0.6,
            ),
          ),
          SizedBox(height: AppSizes.spaceSm),
          Text(
            word.meaning,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.w(14)),
            decoration: BoxDecoration(
              color: AppColors.homeCardLavender,
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
            ),
            child: Column(
              children: [
                Text(
                  'EXAMPLE',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(11),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: AppSizes.spaceSm),
                Text(
                  word.example,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSizes.spaceLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _WordActionButton(
                label: 'Listen',
                icon: Icons.volume_up_rounded,
                filled: true,
                onTap: () => viewModel.listenWord(context),
              ),
              SizedBox(width: AppSizes.w(32)),
              _WordActionButton(
                label: 'Save',
                icon: Icons.bookmark_outline_rounded,
                filled: false,
                isActive: viewModel.isWordSaved(word.word),
                onTap: () => viewModel.toggleSaveWord(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WordActionButton extends StatelessWidget {
  const _WordActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
    this.isActive = false,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: AppSizes.w(52),
            height: AppSizes.w(52),
            decoration: BoxDecoration(
              color: filled ? AppColors.primaryColor : AppColors.white,
              shape: BoxShape.circle,
              border: filled
                  ? null
                  : Border.all(
                      color: isActive
                          ? AppColors.primaryColor
                          : AppColors.primaryColor,
                      width: 1.5,
                    ),
            ),
            child: Icon(
              isActive ? Icons.bookmark_rounded : icon,
              color: filled ? AppColors.white : AppColors.primaryColor,
              size: AppSizes.iconMedium,
            ),
          ),
          SizedBox(height: AppSizes.h(6)),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(12),
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
