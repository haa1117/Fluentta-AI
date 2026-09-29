import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class UpdatePasswordViewModel extends ChangeNotifier {
  UpdatePasswordViewModel(this._authRepository) {
    currentPasswordController.addListener(notifyListeners);
    newPasswordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  final AuthRepository _authRepository;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isFormValid {
    final current = currentPasswordController.text;
    final password = newPasswordController.text;
    final confirm = confirmPasswordController.text;
    return current.isNotEmpty &&
        password.length >= 8 &&
        password == confirm;
  }

  Future<bool> save(VoidCallback onSuccess) async {
    if (_isLoading || !isFormValid) return false;

    _isLoading = true;
    notifyListeners();
    AnalyticsService.instance.log(
      AnalyticsEvents.profilePasswordUpdateSubmitted,
    );

    try {
      await _authRepository.updatePasswordWithCurrent(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      AnalyticsService.instance.log(
        AnalyticsEvents.profilePasswordUpdateSucceeded,
      );
      onSuccess();
      return true;
    } catch (error) {
      AnalyticsService.instance.log(
        AnalyticsEvents.profilePasswordUpdateFailed,
        {
          AnalyticsParams.errorType: 'authentication',
          AnalyticsParams.errorCode:
              error is FirebaseAuthException ? error.code : 'unknown',
        },
      );
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
    currentPasswordController.removeListener(notifyListeners);
    newPasswordController.removeListener(notifyListeners);
    confirmPasswordController.removeListener(notifyListeners);
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
