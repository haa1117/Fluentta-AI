import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/models/setup_option_model.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';

class SetupViewModel extends ChangeNotifier {
  SetupViewModel(
    this._localStorage,
    this._userRepository,
    this._authRepository,
  ) {
    _selectedGoal = _localStorage.englishGoal ?? 'work';
    _selectedLevel = _localStorage.englishLevel ?? 'elementary';
    _selectedDailyGoal = _localStorage.dailyGoalMinutes?.toString() ?? '10';
  }

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  final PageController pageController = PageController();

  static const int totalSteps = 3;
  int _currentStep = 0;
  bool _isLoading = false;

  late String _selectedGoal;
  late String _selectedLevel;
  late String _selectedDailyGoal;

  int get currentStep => _currentStep + 1;
  bool get isLoading => _isLoading;
  String get selectedGoal => _selectedGoal;
  String get selectedLevel => _selectedLevel;
  String get selectedDailyGoal => _selectedDailyGoal;

  void selectGoal(String id) {
    _selectedGoal = id;
    notifyListeners();
  }

  void selectLevel(String id) {
    _selectedLevel = id;
    notifyListeners();
  }

  void selectDailyGoal(String id) {
    _selectedDailyGoal = id;
    notifyListeners();
  }

  void resetForRetake() {
    _currentStep = 0;
    _selectedGoal = _localStorage.englishGoal ?? 'work';
    _selectedLevel = _localStorage.englishLevel ?? 'elementary';
    _selectedDailyGoal = _localStorage.dailyGoalMinutes?.toString() ?? '10';
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    notifyListeners();
  }

  Future<void> nextStep(VoidCallback onComplete) async {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
      await pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    await _completeSetup(onComplete);
  }

  Future<void> _completeSetup(VoidCallback onComplete) async {
    if (_isLoading) return;

    final uid = _authRepository.currentUser?.uid;
    if (uid == null) {
      throw StateError('You must be signed in to complete setup.');
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _userRepository.completeSetup(
        uid: uid,
        englishGoal: _selectedGoal,
        englishLevel: _selectedLevel,
        dailyGoalMinutes: int.parse(_selectedDailyGoal),
      );
      onComplete();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(Object error, AppLocalizations l10n) =>
      AuthExceptionHandler.getMessage(error, l10n);

  String titleForStep(int step) {
    return switch (step) {
      0 => 'What\'s Your English Goal?',
      1 => 'Start Your Starting Point',
      2 => 'Set Your Daily Goal',
      _ => '',
    };
  }

  String subtitleForStep(int step) {
    return switch (step) {
      0 => 'Your tutor will create practice based on your goal.',
      1 => 'We\'ll personalize your lessons based on your level.',
      2 => 'Small daily practice builds real English fluency.',
      _ => '',
    };
  }

  List<SetupOptionModel> optionsForStep(int step) {
    return switch (step) {
      0 => SetupOptions.englishGoals,
      1 => SetupOptions.englishLevels,
      2 => SetupOptions.dailyGoals,
      _ => const [],
    };
  }

  String selectedIdForStep(int step) {
    return switch (step) {
      0 => _selectedGoal,
      1 => _selectedLevel,
      2 => _selectedDailyGoal,
      _ => '',
    };
  }

  void selectForStep(int step, String id) {
    switch (step) {
      case 0:
        selectGoal(id);
      case 1:
        selectLevel(id);
      case 2:
        selectDailyGoal(id);
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
