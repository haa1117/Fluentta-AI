import 'package:flutter/material.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  ResetPasswordViewModel() {
    newPasswordController.addListener(notifyListeners);
    confirmPasswordController.addListener(notifyListeners);
  }

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isFormValid {
    final password = newPasswordController.text;
    final confirm = confirmPasswordController.text;
    return password.length >= 8 && password == confirm;
  }

  Future<void> updatePassword(VoidCallback onSuccess) async {
    if (_isLoading || !isFormValid) return;

    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
    onSuccess();
  }

  @override
  void dispose() {
    newPasswordController.removeListener(notifyListeners);
    confirmPasswordController.removeListener(notifyListeners);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
