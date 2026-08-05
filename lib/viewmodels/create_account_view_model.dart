import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
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

  Future<bool> createAccount({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    if (_isLoading) return false;

    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please fill in all fields.',
      );
    }

    if (password.length < 8) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'Password must be at least 8 characters.',
      );
    }

    _isLoading = true;
    notifyListeners();

    LoadingDialog.show(
      context,
      title: 'Creating your account...',
      subtitle: 'Please wait a moment.',
    );

    try {
      await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
      onSuccess();
      return true;
    } finally {
      if (context.mounted) {
        LoadingDialog.hide(context);
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  String getErrorMessage(Object error) => AuthExceptionHandler.getMessage(error);

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
