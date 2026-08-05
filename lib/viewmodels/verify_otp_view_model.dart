import 'dart:async';

import 'package:flutter/material.dart';

class VerifyOtpViewModel extends ChangeNotifier {
  VerifyOtpViewModel({required this.maskedEmail});

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

  String get resendText {
    if (canResend) return 'Resend code';
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return 'Resend code in $minutes:$seconds';
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

  Future<void> verifyCode(VoidCallback onSuccess) async {
    if (_isLoading || !isCodeComplete) return;

    _isLoading = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
    onSuccess();
  }

  void resendCode() {
    if (!canResend) return;
    initTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
