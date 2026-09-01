import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/data/models/pronunciation_phrase_model.dart';

class WordFeedbackTile extends StatelessWidget {
  final bool isDark;
  const WordFeedbackTile({super.key, required this.feedback, required this.isDark});

  final PronunciationWordFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isHigh = feedback.isHighConfidence;
    final accent = isHigh ? AppColors.learnSuccessGreen : const Color(0xFFD97706);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSizes.h(10)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(16),
        vertical: AppSizes.h(14),
      ),
      decoration: BoxDecoration(
        color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border(
          left: BorderSide(color: accent, width: 4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HighlightedWord(
                  word: feedback.word,
                  weakCharIndices: feedback.weakCharIndices,
                  isHighConfidence: isHigh, isDark: isDark,
                ),
                SizedBox(height: AppSizes.h(4)),
                Text(
                  l10n.confidencePercent(feedback.confidence),
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
                if (feedback.spokenWord != null &&
                    feedback.spokenWord!.toLowerCase() !=
                        feedback.word.toLowerCase()) ...[
                  SizedBox(height: AppSizes.h(4)),
                  Text(
                    l10n.heardAs(feedback.spokenWord!),
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      color: AppColors.profileSubtitleColor,
                    ),
                  ),
                ],
                if (feedback.weakSounds.isNotEmpty) ...[
                  SizedBox(height: AppSizes.h(6)),
                  Text(
                    l10n.focusOnSounds(feedback.weakSounds.join(', ')),
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD97706),
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSizes.w(8)),
          Icon(
            isHigh ? Icons.check_circle_outline : Icons.info_outline_rounded,
            color: accent,
            size: AppSizes.sp(24),
          ),
        ],
      ),
    );
  }
}

class PhraseWordHighlights extends StatelessWidget {
  const PhraseWordHighlights({super.key, required this.words});

  final List<PronunciationWordFeedback> words;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.w(8),
      runSpacing: AppSizes.h(8),
      alignment: WrapAlignment.center,
      children: words.map((word) {
        final isHigh = word.isHighConfidence;
        final bg = isHigh
            ? AppColors.learnSuccessGreen.withValues(alpha: 0.12)
            : const Color(0xFFFFF7ED);
        final border = isHigh
            ? AppColors.learnSuccessGreen.withValues(alpha: 0.35)
            : const Color(0xFFFDBA74);
        final textColor =
            isHigh ? AppColors.learnSuccessGreen : const Color(0xFFD97706);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(10),
            vertical: AppSizes.h(6),
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppSizes.w(20)),
            border: Border.all(color: border),
          ),
          child: Text(
            word.word,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(14),
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HighlightedWord extends StatelessWidget {
  final bool isDark;
  const _HighlightedWord({
    required this.word,
    required this.weakCharIndices,
    required this.isHighConfidence, required this.isDark,
  });

  final String word;
  final List<int> weakCharIndices;
  final bool isHighConfidence;

  @override
  Widget build(BuildContext context) {
    if (isHighConfidence || weakCharIndices.isEmpty) {
      return Text(
        word,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(16),
          fontWeight: FontWeight.w700,
          color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      );
    }

    final weakSet = weakCharIndices.toSet();
    final spans = <TextSpan>[];

    for (var i = 0; i < word.length; i++) {
      final isWeak = weakSet.contains(i);
      spans.add(
        TextSpan(
          text: word[i],
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            // color: isWeak ? const Color(0xFFD97706) : AppColors.textPrimary,
            // backgroundColor:
            //     isWeak ? const Color(0xFFFFF7ED) : Colors.transparent,
            fontWeight: isWeak ? FontWeight.w800 : FontWeight.w700,
          ),
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(16),
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary
        ),
        children: spans,
      ),
    );
  }
}
