import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SpeakPronunciationTile extends StatelessWidget {
  const SpeakPronunciationTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.w(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppAssets.aiTutor,
                  width: AppSizes.w(48),
                  height: AppSizes.w(48),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: AppSizes.w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pronunciationPractice,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(2)),
                    Text(
                      l10n.pronunciationPracticeSub,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiary,
                size: AppSizes.sp(22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
