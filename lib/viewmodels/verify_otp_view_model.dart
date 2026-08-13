import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  VerifyOtpViewModel({
    required this.authRepository,
    required this.email,
    required this.maskedEmail,
  });

  final AuthRepository authRepository;
  final String email;
  final String maskedEmail;

  static const int otpLength = 4;
  static const int resendDuration = 30;

  String _otpCode = '';
  int _resendSeconds = resendDuration;
  Timer? _timer;
  bool _isLoading = false;

  String get otpCode => _otpCode;
  int get resendSeconds => _resendSeconds;
  bool get isLoading => _isLoading;
  bool get isCodeComplete => _otpCode.length == otpLength;
  bool get canResend => _resendSeconds == 0;

  String resendText(AppLocalizations l10n) {
    if (canResend) return l10n.resendCode;
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return l10n.resendCodeIn('$minutes:$seconds');
  }

  void initTimer() {
    _resendSeconds = resendDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  void updateOtp(String code) {
    _otpCode = code;
    notifyListeners();
  }

  Future<bool> verifyCode(VoidCallback onSuccess) async {
    if (_isLoading || !isCodeComplete) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final storedOobCode = authRepository.resetOobCode;
      if (storedOobCode != null && storedOobCode.isNotEmpty) {
        await authRepository.verifyPasswordResetCode(storedOobCode);
      } else if (authRepository.currentUser != null) {
        // User opened reset link and returned to the app.
      } else {
        // Firebase sends email link; allow continue after user confirms code entry.
        // Reset password screen will use confirmPasswordReset when oobCode is available.
      }
      onSuccess();
      return true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resendCode() async {
    if (!canResend) return false;

    try {
      await authRepository.sendPasswordResetEmail(email);
      initTimer();
      notifyListeners();
      return true;
    } catch (e) {
      rethrow;
    }
  }

  String getErrorMessage(Object error, AppLocalizations l10n) =>
      AuthExceptionHandler.getMessage(error, l10n);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
