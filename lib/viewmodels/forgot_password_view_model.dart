import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  ForgotPasswordViewModel(this._authRepository);

  final AuthRepository _authRepository;

  final emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> sendVerificationCode(VoidCallback onSuccess) async {
    final email = emailController.text.trim();
    if (_isLoading || email.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter your email address.',
      );
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.sendPasswordResetEmail(email);
      onSuccess();
      return true;
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

  String getErrorMessage(Object error) => AuthExceptionHandler.getMessage(error);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
