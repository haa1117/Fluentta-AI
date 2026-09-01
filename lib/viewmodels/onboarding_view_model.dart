import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/onboarding_page_model.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel(
    this._localStorage,
    this._userRepository,
    this._authRepository,
  );

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

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
    await _syncToFirestoreIfLoggedIn();
    onComplete();
  }

  Future<void> _syncToFirestoreIfLoggedIn() async {
    final uid = _authRepository.currentUser?.uid;
    if (uid == null) return;
    await _userRepository.updateOnboarding(uid: uid, isComplete: true);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
