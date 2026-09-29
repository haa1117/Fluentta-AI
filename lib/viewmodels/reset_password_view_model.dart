import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  ResetPasswordViewModel(this._authRepository) {
    newPasswordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  final AuthRepository _authRepository;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isFormValid {
    final password = newPasswordController.text;
    final confirm = confirmPasswordController.text;
    return password.length >= 8 && password == confirm;
  }

  /// Whether the app has a verified deep-link reset code, or a signed-in
  /// session, that lets the reset actually go through.
  bool get isResetTokenValid =>
      _authRepository.hasVerifiedResetCode ||
      _authRepository.currentUser != null;

  Future<bool> updatePassword(VoidCallback onSuccess) async {
    if (_isLoading) return false;

    final password = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (password.length < 8) {
      AnalyticsService.instance.log(AnalyticsEvents.passwordUpdateFailed, {
        AnalyticsParams.errorType: 'validation',
        AnalyticsParams.failureStage: 'validation',
        AnalyticsParams.failedRule: 'minimum_length',
      });
      return false;
    }

    if (password != confirm) {
      AnalyticsService.instance.log(AnalyticsEvents.passwordUpdateFailed, {
        AnalyticsParams.errorType: 'validation',
        AnalyticsParams.failureStage: 'validation',
        AnalyticsParams.failedRule: 'passwords_do_not_match',
      });
      return false;
    }

    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(AnalyticsEvents.passwordUpdateSubmitted, {
      AnalyticsParams.resetTokenValid: isResetTokenValid,
    });

    try {
      await _authRepository.confirmPasswordReset(
        newPassword: newPasswordController.text,
      );
      AnalyticsService.instance.log(AnalyticsEvents.passwordUpdateSucceeded);
      onSuccess();
      return true;
    } catch (error) {
      final code = error is FirebaseAuthException ? error.code : 'unknown';
      final isTokenError =
          code == 'invalid-action-code' || code == 'expired-action-code';
      AnalyticsService.instance.log(AnalyticsEvents.passwordUpdateFailed, {
        AnalyticsParams.errorType: 'authentication',
        AnalyticsParams.errorCode: code,
        AnalyticsParams.failureStage:
            isTokenError ? 'token_validation' : 'password_update',
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
    newPasswordController.removeListener(notifyListeners);
    confirmPasswordController.removeListener(notifyListeners);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
