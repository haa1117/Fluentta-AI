import 'package:flutter/material.dart';
import 'package:fluentta_ai/widgets/auth/loading_dialog.dart';

class CreateAccountViewModel extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createAccount({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();

    LoadingDialog.show(
      context,
      title: 'Creating your account...',
      subtitle: 'Please wait a moment.',
    );

    await Future<void>.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      LoadingDialog.hide(context);
    }

    _isLoading = false;
    notifyListeners();
    onSuccess();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
