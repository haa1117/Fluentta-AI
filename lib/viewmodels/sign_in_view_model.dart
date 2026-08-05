import 'package:flutter/material.dart';

class SignInViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> signIn({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
    onSuccess();
  }

  Future<void> signInWithGoogle(VoidCallback onSuccess) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    onSuccess();
  }

  Future<void> signInWithApple(VoidCallback onSuccess) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    onSuccess();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
