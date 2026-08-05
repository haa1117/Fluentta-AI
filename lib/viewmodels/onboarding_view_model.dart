import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/onboarding_page_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel(this._localStorage);

  final LocalStorage _localStorage;

  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      imagePath: AppAssets.onboarding1,
      title: 'Meet Your AI English Tutor',
      description:
          'Practice English by chatting or speaking \n with your personal AI tutor',
    ),
    OnboardingPageModel(
      imagePath: AppAssets.onboarding2,
      title: 'Get Instant Corrections',
      description:
          'Fix Grammar, word choice, and sentences while you practice',
    ),
    OnboardingPageModel(
      imagePath: AppAssets.onboarding3,
      title: 'Improve Every Day',
      description:
          'Build your English with daily practice and simple progress tracking',
    ),
  ];

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(VoidCallback onComplete) {
    if (_currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding(onComplete);
    }
  }

  Future<void> skipOnboarding(VoidCallback onComplete) async {
    await completeOnboarding(onComplete);
  }

  Future<void> completeOnboarding(VoidCallback onComplete) async {
    await _localStorage.setOnboardingComplete();
    onComplete();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
