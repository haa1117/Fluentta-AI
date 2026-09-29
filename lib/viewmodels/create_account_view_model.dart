import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/widgets/auth/loading_dialog.dart';

class CreateAccountViewModel extends ChangeNotifier {
  CreateAccountViewModel(this._authRepository);

  final AuthRepository _authRepository;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _loggedStarted = false;

  /// First field focus on the signup form.
  void logStarted() {
    if (_loggedStarted) return;
    _loggedStarted = true;
    AnalyticsService.instance.log(AnalyticsEvents.signupStarted, {
      AnalyticsParams.signupMethod: 'email',
    });
  }

  void _logValidationFailed(String failedRule) {
    AnalyticsService.instance.log(AnalyticsEvents.signupFailed, {
      AnalyticsParams.signupMethod: 'email',
      AnalyticsParams.errorType: 'validation',
      AnalyticsParams.failureStage: 'validation',
      AnalyticsParams.failedRule: failedRule,
    });
  }

  Future<bool> createAccount({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    if (_isLoading) return false;

    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty) {
      _logValidationFailed('missing_name');
      throw FirebaseAuthException(
        code: 'missing-fields',
        message: 'Please fill in all fields.',
      );
    }

    if (email.isEmpty) {
      _logValidationFailed('invalid_email');
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter a valid email address.',
      );
    }

    if (password.isEmpty) {
      _logValidationFailed('minimum_length');
      throw FirebaseAuthException(
        code: 'missing-fields',
        message: 'Please fill in all fields.',
      );
    }

    if (password.length < 8) {
      _logValidationFailed('minimum_length');
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must be at least 8 characters.',
      );
    }

    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.signupSubmitted, {
      AnalyticsParams.signupMethod: 'email',
    });

    LoadingDialog.show(
      context,
      title: context.l10n.creatingAccountTitle,
      subtitle: context.l10n.creatingAccountSubtitle,
    );

    try {
      await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      AnalyticsService.instance.log(AnalyticsEvents.signupSuccess, {
        AnalyticsParams.signupMethod: 'email',
      });
      onSuccess();
      return true;
    } catch (error) {
      AnalyticsService.instance.log(AnalyticsEvents.signupFailed, {
        AnalyticsParams.signupMethod: 'email',
        AnalyticsParams.errorType: 'authentication',
        AnalyticsParams.errorCode:
            error is FirebaseAuthException ? error.code : 'unknown',
        AnalyticsParams.failureStage: 'backend_auth',
      });
      rethrow;
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(Object error, AppLocalizations l10n) =>
      AuthExceptionHandler.getMessage(error, l10n);

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
