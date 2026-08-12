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
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiSpeakingTutor,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(20),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(6)),
                    Text(
                      l10n.aiSpeakingTutorDesc,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(13),
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: AppSizes.h(10)),
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
              ),
              SizedBox(width: AppSizes.w(8)),
              Image.asset(
                'assets/images/start_chat.png',
                width: AppSizes.w(90),
                height: AppSizes.w(90),
                fit: BoxFit.contain,
              ),
            ],
          ),
          SizedBox(height: AppSizes.h(16)),
          SizedBox(
            width: double.infinity,
            height: AppSizes.h(48),
            child: ElevatedButton.icon(
              onPressed: onStartChat,
              icon: Icon(Icons.mic_none_rounded, size: AppSizes.sp(20)),
              label: Text(
                l10n.startAiChat,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                ),
              ),
            ),
          ),
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
          fontSize: AppSizes.sp(11),
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
