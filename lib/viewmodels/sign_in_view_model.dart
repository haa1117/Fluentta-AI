import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/core/utils/online_gate.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class SignInViewModel extends ChangeNotifier {
  SignInViewModel(this._authRepository);

  final AuthRepository _authRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loggedStarted = false;

  /// First field focus on the login form.
  void logStarted() {
    if (_loggedStarted) return;
    _loggedStarted = true;
    AnalyticsService.instance.log(AnalyticsEvents.loginStarted, {
      AnalyticsParams.loginMethod: 'email',
    });
  }

  Future<bool> signIn({required Future<void> Function() onSuccess}) async {
    if (_isLoading) return false;
    OnlineGate.throwIfOffline();

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty && password.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-fields',
        message: 'Please fill in all fields.',
      );
    }
    if (email.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter a valid email address.',
      );
    }
    if (password.trim().isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-password',
        message: 'Please enter your password.',
      );
    }

    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.loginSubmitted, {
      AnalyticsParams.loginMethod: 'email',
    });

    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      AnalyticsService.instance.log(AnalyticsEvents.loginSuccess, {
        AnalyticsParams.loginMethod: 'email',
      });
      await onSuccess();
      return true;
    } catch (error) {
      AnalyticsService.instance.log(AnalyticsEvents.loginFailed, {
        AnalyticsParams.loginMethod: 'email',
        AnalyticsParams.errorType: 'authentication',
        AnalyticsParams.errorCode:
            error is FirebaseAuthException ? error.code : 'unknown',
        AnalyticsParams.failureStage: 'backend_auth',
      });
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle({
    required Future<void> Function() onSuccess,
    required void Function(String signupMethod) onNewUser,
  }) async {
    if (_isLoading) return false;
    OnlineGate.throwIfOffline();
    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.socialAuthStarted, {
      AnalyticsParams.authProvider: 'google',
      AnalyticsParams.sourceScreen: 'login_email',
    });

    try {
      final result = await _authRepository.signInWithGoogle();
      if (result == null) {
        AnalyticsService.instance.log(AnalyticsEvents.socialAuthCancelled, {
          AnalyticsParams.authProvider: 'google',
          AnalyticsParams.sourceScreen: 'login_email',
        });
        return false;
      }

      if (result.isNewUser) {
        // Per the PRD, a new-user provider sign-in fires signup_success
        // (not login_success) exactly once.
        AnalyticsService.instance.log(AnalyticsEvents.signupSuccess, {
          AnalyticsParams.signupMethod: 'google',
        });
        onNewUser('google');
      } else {
        AnalyticsService.instance.log(AnalyticsEvents.loginSuccess, {
          AnalyticsParams.loginMethod: 'google',
        });
        await onSuccess();
      }
      return true;
    } catch (error) {
      AnalyticsService.instance.log(AnalyticsEvents.socialAuthFailed, {
        AnalyticsParams.authProvider: 'google',
        AnalyticsParams.errorType: 'authentication',
        AnalyticsParams.errorCode:
            error is FirebaseAuthException ? error.code : 'unknown',
        AnalyticsParams.failureStage: 'provider_callback',
      });
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithApple({
    required Future<void> Function() onSuccess,
    required void Function(String signupMethod) onNewUser,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.socialAuthStarted, {
      AnalyticsParams.authProvider: 'apple',
      AnalyticsParams.sourceScreen: 'login_email',
    });

    try {
      final result = await _authRepository.signInWithApple();
      if (result.isNewUser) {
        AnalyticsService.instance.log(AnalyticsEvents.signupSuccess, {
          AnalyticsParams.signupMethod: 'apple',
        });
        onNewUser('apple');
      } else {
        AnalyticsService.instance.log(AnalyticsEvents.loginSuccess, {
          AnalyticsParams.loginMethod: 'apple',
        });
        await onSuccess();
      }
      return true;
    } catch (error) {
      AnalyticsService.instance.log(AnalyticsEvents.socialAuthFailed, {
        AnalyticsParams.authProvider: 'apple',
        AnalyticsParams.errorType: 'authentication',
        AnalyticsParams.errorCode:
            error is FirebaseAuthException ? error.code : 'unknown',
        AnalyticsParams.failureStage: 'provider_callback',
      });
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(Object error, AppLocalizations l10n) =>
      AuthExceptionHandler.getMessage(error, l10n);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
