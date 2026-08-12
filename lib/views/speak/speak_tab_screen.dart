import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/views/ai_tutor/ai_tutor_screen.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/speak/speak_ad_banner.dart';
import 'package:fluentta_ai/widgets/speak/speak_ai_tutor_card.dart';
import 'package:fluentta_ai/widgets/speak/speak_pronunciation_tile.dart';
import 'package:provider/provider.dart';

class SpeakTabScreen extends StatelessWidget {
  const SpeakTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final lives = context.watch<HomeViewModel>().lives;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
                AppSizes.horizontalPadding,
                0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.speakWithAiTutorTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.w(12),
                      vertical: AppSizes.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.homeCardLavender,
                      borderRadius: BorderRadius.circular(AppSizes.w(20)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '$lives',
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: AppSizes.w(4)),
                        Icon(
                          Icons.favorite,
                          color: AppColors.heartRed,
                          size: AppSizes.sp(16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.horizontalPadding,
                  AppSizes.spaceMd,
                  AppSizes.horizontalPadding,
                  AppSizes.spaceLg,
                ),
                child: Column(
                  children: [
                    SpeakAiTutorCard(
                      onStartChat: () => AiTutorScreen.open(context),
                    ),
                    SizedBox(height: AppSizes.h(14)),
                    SpeakPronunciationTile(
                      onTap: () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => const PronunciationFlow(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.h(20)),
                    const SpeakAdBanner(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
