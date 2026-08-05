import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/language_view_model.dart';
import 'package:fluentta_ai/widgets/common/ad_placeholder.dart';
import 'package:fluentta_ai/widgets/common/language_banner.dart';
import 'package:fluentta_ai/widgets/common/language_tile.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/common/section_header.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<LanguageViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.horizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSizes.spaceMd),
                    const LanguageBanner(),
                    SizedBox(height: AppSizes.spaceLg),
                    const SectionHeader(title: 'Suggested For You'),
                    SizedBox(height: AppSizes.spaceSm),
                    ...LanguageViewModel.suggestedLanguages.map(
                      (language) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                        child: LanguageTile(
                          flagEmoji: language.flagEmoji,
                          languageName: language.name,
                          subtitle: language.subtitle,
                          isSelected:
                              viewModel.selectedLanguageCode == language.code,
                          onTap: () => viewModel.selectLanguage(language.code),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    const SectionHeader(title: 'Other Languages'),
                    SizedBox(height: AppSizes.spaceSm),
                    ...LanguageViewModel.otherLanguages.map(
                      (language) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                        child: LanguageTile(
                          flagEmoji: language.flagEmoji,
                          languageName: language.name,
                          isSelected:
                              viewModel.selectedLanguageCode == language.code,
                          onTap: () => viewModel.selectLanguage(language.code),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    const AdPlaceholder(),
                    SizedBox(height: AppSizes.spaceMd),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.horizontalPadding,
                0,
                AppSizes.horizontalPadding,
                AppSizes.spaceMd,
              ),
              child: PrimaryButton(
                text: 'Continue',
                onPressed: () => viewModel.continueWithLanguage(onComplete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
