import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/widgets/common/primary_button_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class SpeakAiTutorCard extends StatelessWidget {
  const SpeakAiTutorCard({super.key, required this.onStartChat});

  final VoidCallback onStartChat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.sp(20)),
        border: Border.all(color: AppColors.borderLight),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.aiSpeakingTutor,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(25),
                            fontWeight: FontWeight.w700,
                            color: AppColors.primarySecondaryColor,
                          ),
                        ),
                        SizedBox(height: AppSizes.h(6)),
                        Text(
                          l10n.aiSpeakingTutorDesc,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(14),
                            color: AppColors.profileSubtitleColor,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Image.asset(
                      AppAssets.aiSpeakingTutorBird,
                      width: AppSizes.w(120),
                      height: AppSizes.w(120),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.h(20)),

              Wrap(
                spacing: AppSizes.w(6),
                runSpacing: AppSizes.h(6),
                children: [
                  _TagChip(label: l10n.tagVoice),
                  _TagChip(label: l10n.tagText),
                  _TagChip(label: l10n.tagCorrections),
                ],
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(20)),
          PrimaryButtonWithIcon(onTap: onStartChat, btnText:  l10n.startAiChat),
        ],
      ),
    );
  }
}


class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.w(10),
        vertical: AppSizes.h(4),
      ),
      decoration: BoxDecoration(
        color: AppColors.homeCardLavender,
        borderRadius: BorderRadius.circular(AppSizes.w(20)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.plusJakartaSans,
          fontSize: AppSizes.sp(12),
          fontWeight: FontWeight.w600,
          color: Color(0xff2C0051),
        ),
      ),
    );
  }
}
