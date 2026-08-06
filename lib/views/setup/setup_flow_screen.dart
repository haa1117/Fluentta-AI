import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/setup_view_model.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/setup/setup_banner_ad.dart';
import 'package:fluentta_ai/widgets/setup/setup_option_tile.dart';
import 'package:fluentta_ai/widgets/setup/setup_progress_header.dart';
import 'package:provider/provider.dart';

class SetupFlowScreen extends StatelessWidget {
  const SetupFlowScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<SetupViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
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
  });

  final int stepIndex;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SetupViewModel>();
    final options = viewModel.optionsForStep(stepIndex);
    final selectedId = viewModel.selectedIdForStep(stepIndex);
    final isLastStep = stepIndex == SetupViewModel.totalSteps - 1;

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
                  title: viewModel.titleForStep(stepIndex),
                  subtitle: viewModel.subtitleForStep(stepIndex),
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
                      onTap: () => viewModel.selectForStep(stepIndex, option.id),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.spaceMd),
                const SetupBannerAd(),
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
            text: isLastStep ? 'Get Started' : 'Next',
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
                          viewModel.getErrorMessage(e),
                        );
                      }
                    }
                  },
          ),
        ),
      ],
    );
  }
}
