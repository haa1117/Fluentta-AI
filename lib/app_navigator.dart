import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/viewmodels/onboarding_view_model.dart';
import 'package:fluentta_ai/viewmodels/setup_view_model.dart';
import 'package:fluentta_ai/viewmodels/sign_in_view_model.dart';
import 'package:fluentta_ai/viewmodels/splash_view_model.dart';
import 'package:fluentta_ai/views/auth/account_created_screen.dart';
import 'package:fluentta_ai/views/auth/sign_in_screen.dart';
import 'package:fluentta_ai/views/main/main_shell_screen.dart';
import 'package:fluentta_ai/views/language/language_selection_screen.dart';
import 'package:fluentta_ai/views/onboarding/onboarding_screen.dart';
import 'package:fluentta_ai/views/setup/setup_flow_screen.dart';
import 'package:fluentta_ai/viewmodels/reset_password_view_model.dart';
import 'package:fluentta_ai/views/auth/reset_password_screen.dart';
import 'package:fluentta_ai/views/splash/splash_screen.dart';
import 'package:provider/provider.dart';

enum AppFlow {
  splash,
  onboarding,
  language,
  signIn,
  accountCreated,
  setup,
  home,
  passwordReset,
}

class AppNavigator extends StatefulWidget {
  const AppNavigator({
    super.key,
    required this.localStorage,
    required this.authRepository,
    required this.userRepository,
  });

  final LocalStorage localStorage;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late AppFlow _currentFlow;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _currentFlow = widget.authRepository.shouldLaunchDirectToPasswordReset
        ? AppFlow.passwordReset
        : AppFlow.splash;
    widget.authRepository.passwordResetSignal.addListener(_onPasswordResetSignal);
    widget.authRepository.passwordResetCompleteSignal
        .addListener(_onPasswordResetComplete);
    _authSubscription = widget.authRepository.authStateChanges.listen((user) {
      if (!mounted) return;
      if (widget.authRepository.shouldOpenPasswordResetScreen) return;
      if (user != null &&
          _currentFlow != AppFlow.home &&
          _currentFlow != AppFlow.setup &&
          _currentFlow != AppFlow.accountCreated &&
          _currentFlow != AppFlow.splash) {
        if (widget.localStorage.hasCompletedSetup) {
          setState(() => _currentFlow = AppFlow.home);
        }
      } else if ((user == null || !widget.localStorage.isLoggedIn) &&
          _isSignedInFlow(_currentFlow)) {
        setState(() => _currentFlow = AppFlow.signIn);
      }
    });
  }

  @override
  void dispose() {
    widget.authRepository.passwordResetSignal.removeListener(_onPasswordResetSignal);
    widget.authRepository.passwordResetCompleteSignal
        .removeListener(_onPasswordResetComplete);
    _authSubscription?.cancel();
    super.dispose();
  }

  void _onPasswordResetSignal() {
    if (!mounted || !widget.authRepository.hasVerifiedResetCode) return;
    setState(() => _currentFlow = AppFlow.passwordReset);
  }

  void _onPasswordResetComplete() {
    if (!mounted) return;
    setState(() => _currentFlow = AppFlow.signIn);
  }

  AppFlow _resolvePostSplashFlow() {
    if (widget.authRepository.currentUser != null ||
        widget.localStorage.isLoggedIn) {
      if (widget.localStorage.hasCompletedSetup) {
        return AppFlow.home;
      }
      return AppFlow.setup;
    }
    if (widget.localStorage.shouldShowOnboarding) {
      return AppFlow.onboarding;
    }
    if (widget.localStorage.shouldShowLanguage) {
      return AppFlow.language;
    }
    return AppFlow.signIn;
  }

  void _completeSplash() {
    setState(() => _currentFlow = _resolvePostSplashFlow());
  }

  void _completePasswordResetFlow() {
    widget.authRepository.completePasswordResetFlow();
  }

  void _goToLanguage() {
    setState(() => _currentFlow = AppFlow.language);
  }

  void _goToSignIn() {
    setState(() => _currentFlow = AppFlow.signIn);
  }

  void _goToAccountCreated() {
    setState(() => _currentFlow = AppFlow.accountCreated);
  }

  void _goToSetup() {
    setState(() => _currentFlow = AppFlow.setup);
  }

  void _goToHome() {
    setState(() => _currentFlow = AppFlow.home);
  }

  bool _isSignedInFlow(AppFlow flow) {
    return switch (flow) {
      AppFlow.home || AppFlow.setup || AppFlow.accountCreated => true,
      _ => false,
    };
  }

  Future<void> _handleSignInSuccess() async {
    final uid = widget.authRepository.currentUser?.uid;
    if (uid != null) {
      await widget.userRepository.syncSetupFromFirestore(uid);
    }
    if (!mounted) return;
    if (widget.localStorage.hasCompletedSetup) {
      _goToHome();
    } else {
      _goToSetup();
    }
  }

  Future<void> _continueFromAccountCreated() async {
    final uid = widget.authRepository.currentUser?.uid;
    if (uid != null) {
      await widget.userRepository.syncSetupFromFirestore(uid);
    }
    if (!mounted) return;
    if (widget.localStorage.hasCompletedSetup) {
      _goToHome();
    } else {
      _goToSetup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SplashViewModel(widget.authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OnboardingViewModel(
            widget.localStorage,
            widget.userRepository,
            widget.authRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SignInViewModel(widget.authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => SetupViewModel(
            widget.localStorage,
            widget.userRepository,
            widget.authRepository,
          ),
        ),
      ],
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_currentFlow) {
          AppFlow.splash => SplashScreen(
              key: const ValueKey('splash'),
              onComplete: _completeSplash,
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
              onSuccess: _handleSignInSuccess,
              onAccountCreated: _goToAccountCreated,
            ),
          AppFlow.accountCreated => AccountCreatedScreen(
              key: const ValueKey('accountCreated'),
              onContinue: _continueFromAccountCreated,
            ),
          AppFlow.setup => SetupFlowScreen(
              key: const ValueKey('setup'),
              onComplete: _goToHome,
            ),
          AppFlow.home => const MainShellScreen(key: ValueKey('home')),
          AppFlow.passwordReset => ChangeNotifierProvider(
              key: const ValueKey('passwordReset'),
              create: (_) => ResetPasswordViewModel(widget.authRepository),
              child: ResetPasswordScreen(
                isDeepLinkFlow: true,
                onFlowComplete: _completePasswordResetFlow,
              ),
            ),
        },
      ),
    );
  }
}
