import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/language_view_model.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/widgets/ads/ad_banner_widget.dart';
import 'package:fluentta_ai/widgets/common/language_banner.dart';
import 'package:fluentta_ai/widgets/common/language_tile.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<LanguageViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onComplete = widget.onComplete;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('language_selection');
      viewModel.logViewed();
    }

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
                    ...viewModel.languages(l10n).map(
                      (language) => Padding(
                        padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                        child: LanguageTile(
                          isDark: isDark,
                          flagAsset: language.flagAsset,
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
                    isLoading: viewModel.isContinuing,
                    onPressed: viewModel.isContinuing
                        ? null
                        : () => viewModel.continueWithLanguage(onComplete),
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
