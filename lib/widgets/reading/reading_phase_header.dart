import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class ReadingPhaseHeader extends StatelessWidget {
  const ReadingPhaseHeader({super.key, required this.phaseTitle});

  final String phaseTitle;

  @override
  Widget build(BuildContext context) {
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
            context.l10n.lessonPhase,
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
          phaseTitle,
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
