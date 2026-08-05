import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(this._authRepository);

  final AuthRepository _authRepository;

  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  Future<void> initializeAndNavigate(VoidCallback onComplete) async {
    if (_isNavigating) return;
    _isNavigating = true;

    await Future.wait([
      Future<void>.delayed(const Duration(seconds: 3)),
      _authRepository.syncCurrentUser(),
    ]);

    onComplete();
  }
}
