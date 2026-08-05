import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
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

  Future<bool> updatePassword(VoidCallback onSuccess) async {
    if (_isLoading || !isFormValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.confirmPasswordReset(
        newPassword: newPasswordController.text,
      );
      onSuccess();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(Object error) => AuthExceptionHandler.getMessage(error);

  @override
  void dispose() {
    newPasswordController.removeListener(notifyListeners);
    confirmPasswordController.removeListener(notifyListeners);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
