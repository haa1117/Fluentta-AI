import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/viewmodels/language_view_model.dart';
import 'package:fluentta_ai/viewmodels/onboarding_view_model.dart';
import 'package:fluentta_ai/viewmodels/sign_in_view_model.dart';
import 'package:fluentta_ai/viewmodels/splash_view_model.dart';
import 'package:fluentta_ai/views/auth/sign_in_screen.dart';
import 'package:fluentta_ai/views/home/home_screen.dart';
import 'package:fluentta_ai/views/language/language_selection_screen.dart';
import 'package:fluentta_ai/views/onboarding/onboarding_screen.dart';
import 'package:fluentta_ai/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

enum AppFlow { splash, onboarding, language, signIn, home }

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key, required this.localStorage});

  final LocalStorage localStorage;

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late AppFlow _currentFlow;

  @override
  void initState() {
    super.initState();
    _currentFlow = _resolveInitialFlow();
  }

  AppFlow _resolveInitialFlow() {
    if (widget.localStorage.isFirstLaunch) {
      if (widget.localStorage.isOnboardingComplete) {
        return AppFlow.language;
      }
      return AppFlow.splash;
    }
    return AppFlow.home;
  }

  void _goToOnboarding() {
    setState(() => _currentFlow = AppFlow.onboarding);
  }

  void _goToLanguage() {
    setState(() => _currentFlow = AppFlow.language);
  }

  void _goToSignIn() {
    setState(() => _currentFlow = AppFlow.signIn);
  }

  void _goToHome() {
    setState(() => _currentFlow = AppFlow.home);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(widget.localStorage),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageViewModel(widget.localStorage),
        ),
        ChangeNotifierProvider(create: (_) => SignInViewModel()),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_currentFlow) {
          AppFlow.splash => SplashScreen(
              key: const ValueKey('splash'),
              onComplete: _goToOnboarding,
            ),
          AppFlow.onboarding => OnboardingScreen(
              key: const ValueKey('onboarding'),
              onComplete: _goToLanguage,
            ),
          AppFlow.language => LanguageSelectionScreen(
              key: const ValueKey('language'),
              onComplete: _goToSignIn,
            ),
          AppFlow.signIn => SignInScreen(
              key: const ValueKey('signIn'),
              onSuccess: _goToHome,
            ),
          AppFlow.home => const HomeScreen(key: ValueKey('home')),
        },
      ),
    );
  }
}
