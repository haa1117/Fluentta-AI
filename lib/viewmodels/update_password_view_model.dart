import 'package:flutter/material.dart';
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

    try {
      await _authRepository.updatePasswordWithCurrent(
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );
      onSuccess();
      return true;
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
