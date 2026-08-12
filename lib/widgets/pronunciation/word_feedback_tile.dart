import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/pronunciation_phrase_model.dart';

class WordFeedbackTile extends StatelessWidget {
  const WordFeedbackTile({super.key, required this.feedback});

  final PronunciationWordFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isHigh = feedback.isHighConfidence;
    final accent = isHigh ? AppColors.learnSuccessGreen : const Color(0xFFF97316);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSizes.h(10)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(16),
        vertical: AppSizes.h(14),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.w(4),
            height: AppSizes.h(44),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.word,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  l10n.confidencePercent(feedback.confidence),
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isHigh ? Icons.check_circle_rounded : Icons.info_outline_rounded,
            color: accent,
            size: AppSizes.sp(24),
          ),
        ],
      ),
    );
  }
}
