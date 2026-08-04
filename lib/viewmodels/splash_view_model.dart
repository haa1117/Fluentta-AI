import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  Future<void> navigateAfterDelay(
    BuildContext context,
    VoidCallback onComplete,
  ) async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Future<void>.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      onComplete();
    }
  }
}
