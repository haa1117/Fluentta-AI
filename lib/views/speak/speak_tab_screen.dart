import 'package:fluentta_ai/widgets/common/appbar_widget.dart';
import 'package:fluentta_ai/widgets/home/todays_lesson_card.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/views/ai_tutor/ai_tutor_screen.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
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
      appBar: AppBarWidget(
        title: 'Speak With AI Tutor',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSizes.horizontalPadding,
            AppSizes.spaceMd,
            AppSizes.horizontalPadding,
            AppSizes.spaceLg,
          ),
          child: Column(
            children: [
              SizedBox(
                height: AppSizes.sp(8),
              ),
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
              SizedBox(height: AppSizes.h(130)),
              const HomeBannerAd(),
            ],
          ),
        ),
      ),
    );
  }
}
