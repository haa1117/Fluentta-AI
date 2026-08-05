import 'dart:async';

import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendVerificationCode(VoidCallback onSuccess) async {
    if (_isLoading || emailController.text.trim().isEmpty) return;

    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
    onSuccess();
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

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
