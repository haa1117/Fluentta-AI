import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/vocabulary_lesson_view_model.dart';
import 'package:provider/provider.dart';

class VocabularyWordCard extends StatelessWidget {
  const VocabularyWordCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<VocabularyLessonViewModel>();
    final word = viewModel.currentWord;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: isDark
            ? Border.all(color: AppColors.borderDarkColor)
            : null,
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.primaryDarkColor : AppColors.primaryColor)
                .withValues(alpha: 0.08),
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
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          Text(
            word.word,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(36),
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.primaryDarkColor
                  : AppColors.primaryBlueColor,
            ),
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            word.phonetic,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(15),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xff4A4455),
            ),
          ),
          SizedBox(height: AppSizes.spaceLg),
          Text(
            'MEANING',
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.primaryDarkColor
                  : AppColors.primaryBlueColor,
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
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xff1D192C),
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSizes.spaceLg),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.w(14)),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.brandDarkSoftColor
                  : AppColors.homeCardLavender,
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
              border: Border.all(
                color: isDark
                    ? AppColors.borderDarkColor
                    : AppColors.borderDarkPrimary,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'EXAMPLE',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(11),
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.primaryDarkColor
                        : AppColors.primaryBlueColor,
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
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : const Color(0xff4A4455),
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
                label: l10n.listen,
                icon: viewModel.isListening
                    ? Icons.volume_off_rounded
                    : Icons.volume_up_rounded,
                filled: true,
                isActive: viewModel.isListening,
                isDark: isDark,
                onTap: () => viewModel.listenWord(context),
              ),
              SizedBox(width: AppSizes.w(32)),
              _WordActionButton(
                label: l10n.save,
                icon: Icons.bookmark_outline_rounded,
                filled: false,
                isActive: viewModel.isWordSaved(word.word),
                isDark: isDark,
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
    required this.isDark,
    this.isActive = false,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor =
        isDark ? AppColors.primaryDarkColor : AppColors.primaryBlueColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: AppSizes.w(52),
            height: AppSizes.w(52),
            decoration: BoxDecoration(
              color: filled
                  ? accentColor
                  : (isDark
                      ? AppColors.surfaceBgDarkColor
                      : AppColors.white),
              shape: BoxShape.circle,
              border: filled
                  ? null
                  : Border.all(
                      color: accentColor,
                      width: 1.5,
                    ),
            ),
            child: Icon(
              isActive ? Icons.bookmark_rounded : icon,
              color: filled ? AppColors.white : accentColor,
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
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
