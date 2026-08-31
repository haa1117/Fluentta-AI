import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/entitlements/user_entitlements.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/setup_view_model.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/common/pro_feature_sheet.dart';
import 'package:fluentta_ai/widgets/setup/setup_banner_ad.dart';
import 'package:fluentta_ai/widgets/setup/setup_option_tile.dart';
import 'package:fluentta_ai/widgets/setup/setup_progress_header.dart';
import 'package:provider/provider.dart';

class SetupFlowScreen extends StatelessWidget {
  const SetupFlowScreen({
    super.key,
    required this.onComplete,
    this.isRetake = false,
  });

  final VoidCallback onComplete;
  final bool isRetake;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<SetupViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: viewModel.pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: SetupViewModel.totalSteps,
                onPageChanged: (_) {},
                itemBuilder: (context, index) {
                  return _SetupStepPage(
                    stepIndex: index,
                    onComplete: onComplete,
                    isRetake: isRetake,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetupStepPage extends StatelessWidget {
  const _SetupStepPage({
    required this.stepIndex,
    required this.onComplete,
    this.isRetake = false,
  });

  final int stepIndex;
  final VoidCallback onComplete;
  final bool isRetake;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<SetupViewModel>();
    final isPremium = LocalStorage.instance.isPremium;
    final options = LocalizedContent.setupOptions(l10n, stepIndex);
    final selectedId = viewModel.selectedIdForStep(stepIndex);
    final isLastStep = stepIndex == SetupViewModel.totalSteps - 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
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
                SetupProgressHeader(
                  currentStep: stepIndex + 1,
                  totalSteps: SetupViewModel.totalSteps,
                  title: LocalizedContent.setupTitle(l10n, stepIndex),
                  subtitle: LocalizedContent.setupSubtitle(l10n, stepIndex), isDark: isDark,
                ),
                SizedBox(height: AppSizes.spaceLg),
                ...options.map(
                  (option) => Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.spaceSm),
                    child: SetupOptionTile(
                      svgIcons: option.svgIcon,
                      title: option.title,
                      subtitle: option.subtitle,
                      isSelected: selectedId == option.id,
                      isLocked: stepIndex == 1 &&
                          !UserEntitlements.canAccessSetupLevel(
                            option.id,
                            isPremium,
                          ),
                      onTap: () {
                        if (stepIndex == 1 &&
                            !UserEntitlements.canAccessSetupLevel(
                              option.id,
                              isPremium,
                            )) {
                          showProFeatureSheet(
                            context,
                            title: 'B2+ content is Pro',
                            message:
                                'Upgrade to Pro to unlock B2 and advanced levels.',
                          );
                          return;
                        }
                        viewModel.selectForStep(stepIndex, option.id);
                      },
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
              const SetupBannerAd(),
              SizedBox(height: AppSizes.spaceSm),

              PrimaryButton(
                text: isLastStep
                    ? (isRetake ? l10n.savePreferences : l10n.getStarted)
                    : l10n.next,
                isLoading: viewModel.isLoading,
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        try {
                          await viewModel.nextStep(onComplete);
                        } catch (e) {
                          if (context.mounted) {
                            SnackbarHelper.showError(
                              context,
                              viewModel.getErrorMessage(e, l10n),
                            );
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
