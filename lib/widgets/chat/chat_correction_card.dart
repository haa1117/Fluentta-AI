import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// Inline grammar-correction card shown under an AI reply when the learner's
/// sentence was rewritten.
class ChatCorrectionCard extends StatelessWidget {
  const ChatCorrectionCard({
    super.key,
    required this.label,
    required this.yourSentenceLabel,
    required this.correctSentenceLabel,
    required this.tipPrefix,
    required this.originalSentence,
    required this.correctedSentence,
    this.tip,
  });

  final String label;
  final String yourSentenceLabel;
  final String correctSentenceLabel;
  final String tipPrefix;
  final String originalSentence;
  final String correctedSentence;
  final String? tip;

  static const Color _teal = Color(0xFF14B8A6);
  static const Color _leftBorder = Color(0xFF6B2FA4);
  static const Color _labelMuted = Color(0xFF4A4455);
  static const Color _tipText = Color(0xFF62259B);
  static const Color _ink = Color(0xFF1D192C);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.w(40)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          AppSizes.w(20),
          AppSizes.h(16),
          AppSizes.w(16),
          AppSizes.h(16),
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.brandDarkSoftColor
              : const Color(0xFFF0DBFF).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppSizes.w(12)),
          border: const Border(
            left: BorderSide(color: _leftBorder, width: 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_fix_high_rounded,
                  size: AppSizes.sp(16),
                  color: _teal,
                ),
                SizedBox(width: AppSizes.w(8)),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                    color: _teal,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.h(10)),
            _fieldLabel(yourSentenceLabel, isDark),
            SizedBox(height: AppSizes.h(2)),
            Text(
              '"$originalSentence"',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(16),
                height: 1.5,
                decoration: TextDecoration.lineThrough,
                color: isDark ? AppColors.redColorDark : AppColors.redColor,
              ),
            ),
            SizedBox(height: AppSizes.h(8)),
            _fieldLabel(correctSentenceLabel, isDark),
            SizedBox(height: AppSizes.h(2)),
            Text(
              '"$correctedSentence"',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(16),
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: isDark ? AppColors.textPrimaryDark : _ink,
              ),
            ),
            if (tip != null && tip!.trim().isNotEmpty) ...[
              SizedBox(height: AppSizes.h(10)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.w(8)),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.white)
                      .withValues(alpha: isDark ? 0.06 : 0.5),
                  borderRadius: BorderRadius.circular(AppSizes.w(8)),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(12),
                      height: 1.35,
                      color: isDark ? AppColors.textSecondaryDark : _tipText,
                    ),
                    children: [
                      TextSpan(
                        text: '$tipPrefix ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: tip!.trim()),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.plusJakartaSans,
        fontSize: AppSizes.sp(12),
        height: 1.33,
        color: isDark ? AppColors.textSecondaryDark : _labelMuted,
      ),
    );
  }
}
