import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// PRD "🎯 Practice" fill-in-the-blank shown after a grammar lesson's rule
/// and examples — a wrong guess shows a correction below and stays
/// retry-able, matching the same pattern used for reading comprehension.
class GrammarPracticeCard extends StatefulWidget {
  const GrammarPracticeCard({
    super.key,
    required this.prompt,
    required this.isAnswered,
    required this.wrongFeedback,
    required this.onCheck,
    required this.isDark,
  });

  final String prompt;
  final bool isAnswered;
  final String? wrongFeedback;
  final ValueChanged<String> onCheck;
  final bool isDark;

  @override
  State<GrammarPracticeCard> createState() => _GrammarPracticeCardState();
}

class _GrammarPracticeCardState extends State<GrammarPracticeCard> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _check() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.onCheck(value);
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = widget.isDark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: isDark ? AppColors.borderDarkColor : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.track_changes_rounded,
                size: AppSizes.sp(18),
                color: isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
              ),
              SizedBox(width: AppSizes.w(8)),
              Text(
                l10n.practiceLabel,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(13),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.spaceMd),
          Text(
            widget.prompt,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(16),
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          TextField(
            controller: _controller,
            enabled: !widget.isAnswered,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _check(),
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(15),
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: l10n.yourAnswerHint,
              filled: true,
              fillColor: isDark
                  ? AppColors.brandDarkSoftColor
                  : AppColors.brandLightSoftColor,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.w(14),
                vertical: AppSizes.h(12),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.w(12)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          if (widget.isAnswered)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSizes.w(12)),
              decoration: BoxDecoration(
                color: AppColors.learnSuccessGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  left: BorderSide(color: AppColors.learnSuccessGreen, width: 3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.learnSuccessGreen,
                    size: AppSizes.sp(18),
                  ),
                  SizedBox(width: AppSizes.w(8)),
                  Text(
                    l10n.practiceCorrectFeedback,
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.learnSuccessGreen,
                    ),
                  ),
                ],
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _check,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h(12)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.w(10)),
                  ),
                ),
                child: Text(
                  l10n.checkAnswerButton,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (widget.wrongFeedback != null) ...[
              SizedBox(height: AppSizes.spaceSm),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.w(12)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: const Border(
                    left: BorderSide(color: Color(0xFFD97706), width: 3),
                  ),
                ),
                child: Text(
                  widget.wrongFeedback!,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFD97706),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
