import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/onboarding_view_model.dart';
import 'package:fluentta_ai/widgets/common/ad_placeholder.dart';
import 'package:fluentta_ai/widgets/common/onboarding_text.dart';
import 'package:fluentta_ai/widgets/common/page_indicator.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:fluentta_ai/widgets/common/secondary_text_button.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<OnboardingViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: viewModel.pageController,
                onPageChanged: viewModel.onPageChanged,
                itemCount: OnboardingViewModel.pages.length,
                itemBuilder: (context, index) {
                  final page = OnboardingViewModel.pages[index];
                  return _OnboardingPageContent(
                    imagePath: page.imagePath,
                    title: page.title,
                    description: page.description,
                    activeIndex: viewModel.currentPage,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
              child: Column(
                children: [
                  const AdPlaceholder(),
                  SizedBox(height: AppSizes.spaceMd),
                  PrimaryButton(
                    text: 'Next',
                    onPressed: () => viewModel.nextPage(onComplete),
                  ),
                  SecondaryTextButton(
                    text: 'Skip',
                    onPressed: () => viewModel.skipOnboarding(onComplete),
                  ),
                  SizedBox(height: AppSizes.spaceSm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageContent extends StatelessWidget {
  const _OnboardingPageContent({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.activeIndex,
  });

  final String imagePath;
  final String title;
  final String description;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: AppSizes.spaceMd),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.w(16)),
            child: Image.asset(
              imagePath,
              height: AppSizes.onboardingImageHeight,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: AppSizes.spaceMd),
          OnboardingText(
            title: title,
            description: description,
          ),
          SizedBox(height: AppSizes.spaceMd),
          PageIndicator(
            count: OnboardingViewModel.pages.length,
            activeIndex: activeIndex,
          ),
        ],
      ),
    );
  }
}
