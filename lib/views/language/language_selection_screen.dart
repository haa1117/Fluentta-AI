import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/language_view_model.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/widgets/ads/ad_banner_widget.dart';
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
    final l10n = context.l10n;
    final viewModel = context.watch<LanguageViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
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
                     LanguageBanner(isDark: isDark),
                    SizedBox(height: AppSizes.spaceLg),
                    SectionHeader(title: l10n.suggestedForYou, isDark: isDark),
                    SizedBox(height: AppSizes.spaceSm),
                    ...viewModel.suggestedLanguages(l10n).map(
                      (language) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                        child: LanguageTile(
                          isDark: isDark,
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
                    SectionHeader(title: l10n.otherLanguages, isDark: isDark),
                    SizedBox(height: AppSizes.spaceSm),
                    ...viewModel.otherLanguages(l10n).map(
                      (language) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                        child: LanguageTile(
                          isDark: isDark,
                          flagEmoji: language.flagEmoji,
                          languageName: language.name,
                          isSelected:
                              viewModel.selectedLanguageCode == language.code,
                          onTap: () => viewModel.selectLanguage(language.code),
                        ),
                      ),
                    ),

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
              child: Column(
                children: [
                  SizedBox(height: AppSizes.spaceMd),
                  const AdNativeWidget(
                    placement: AdPlacement.languageNative,
                  ),

                  SizedBox(height: AppSizes.spaceSm),

                  PrimaryButton(
                    text: l10n.continueBtn,
                    onPressed: () => viewModel.continueWithLanguage(onComplete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
