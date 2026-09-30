import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/core/utils/online_gate.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  ForgotPasswordViewModel(this._authRepository);

  final AuthRepository _authRepository;

  final emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> sendVerificationCode(VoidCallback onSuccess) async {
    OnlineGate.throwIfOffline();
    final email = emailController.text.trim();
    if (_isLoading || email.isEmpty) {
      AnalyticsService.instance.log(AnalyticsEvents.passwordResetRequestFailed, {
        AnalyticsParams.errorType: 'validation',
        AnalyticsParams.errorCode: 'invalid-email',
        AnalyticsParams.failureStage: 'validation',
      });
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter your email address.',
      );
    }

    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.passwordResetRequested, {
      AnalyticsParams.requestMethod: 'email',
    });

    try {
      await _authRepository.sendPasswordResetEmail(email);
      AnalyticsService.instance.log(
        AnalyticsEvents.passwordResetRequestSucceeded,
        {AnalyticsParams.requestMethod: 'email'},
      );
      onSuccess();
      return true;
    } catch (error) {
      final isAuthError = error is FirebaseAuthException;
      AnalyticsService.instance.log(AnalyticsEvents.passwordResetRequestFailed, {
        AnalyticsParams.errorType: 'authentication',
        AnalyticsParams.errorCode: isAuthError ? error.code : 'unknown',
        AnalyticsParams.failureStage:
            isAuthError ? 'backend_response' : 'request_dispatch',
      });
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String get maskedEmail {
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) return 'abc***@gmail.com';

    final parts = email.split('@');
    final name = parts.first;
    final domain = parts.last;
    final visible = name.length <= 3 ? name : name.substring(0, 3);
    return '$visible***@$domain';
  }

  String get email => emailController.text.trim();

  String getErrorMessage(Object error, AppLocalizations l10n) =>
      AuthExceptionHandler.getMessage(error, l10n);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
