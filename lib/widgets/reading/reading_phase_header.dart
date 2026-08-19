import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class ReadingPhaseHeader extends StatelessWidget {
  const ReadingPhaseHeader({
    super.key,
    required this.phaseTitle,
    this.dialoguePartNumber,
    this.isTextPassage = false,
  });

  final String phaseTitle;
  final int? dialoguePartNumber;
  final bool isTextPassage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final displayTitle = dialoguePartNumber != null
        ? (isTextPassage
            ? l10n.readingPassagePart(dialoguePartNumber!)
            : l10n.readingDialoguePart(dialoguePartNumber!))
        : phaseTitle;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(16),
            vertical: AppSizes.h(6),
          ),
          decoration: BoxDecoration(
            color: AppColors.homeCardLavender,
            borderRadius: BorderRadius.circular(AppSizes.w(20)),
          ),
          child: Text(
            l10n.lessonPhase,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(13),
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: AppSizes.spaceSm),
        Text(
          displayTitle,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(16),
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
