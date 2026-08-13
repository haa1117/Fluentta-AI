import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class SignInViewModel extends ChangeNotifier {
  SignInViewModel(this._authRepository);

  final AuthRepository _authRepository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> signIn({
    required VoidCallback onSuccess,
  }) async {
    if (_isLoading) return false;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please enter email and password.',
      );
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );
      onSuccess();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithGoogle({
    required VoidCallback onSuccess,
    required VoidCallback onNewUser,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authRepository.signInWithGoogle();
      if (result == null) return false;

      if (result.isNewUser) {
        onNewUser();
      } else {
        onSuccess();
      }
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithApple({
    required VoidCallback onSuccess,
    required VoidCallback onNewUser,
  }) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authRepository.signInWithApple();
      if (result.isNewUser) {
        onNewUser();
      } else {
        onSuccess();
      }
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
