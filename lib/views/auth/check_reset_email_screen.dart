import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/navigation/password_reset_deep_link_handler.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/auth_exception_handler.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:provider/provider.dart';

class CheckResetEmailScreen extends StatefulWidget {
  const CheckResetEmailScreen({
    super.key,
    required this.email,
    required this.maskedEmail,
  });

  final String email;
  final String maskedEmail;

  @override
  State<CheckResetEmailScreen> createState() => _CheckResetEmailScreenState();
}

class _CheckResetEmailScreenState extends State<CheckResetEmailScreen>
    with WidgetsBindingObserver {
  static const int _resendDuration = 30;

  int _resendSeconds = _resendDuration;
  Timer? _timer;
  bool _isResending = false;
  AuthRepository? _authRepository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authRepository = context.read<AuthRepository>();
      _authRepository!.passwordResetSignal.addListener(_onPasswordResetSignal);
      _tryOpenResetPassword();
    });
  }

  @override
  void dispose() {
    _authRepository?.passwordResetSignal.removeListener(_onPasswordResetSignal);
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _tryOpenResetPassword();
    }
  }

  void _onPasswordResetSignal() {
    _tryOpenResetPassword();
  }

  Future<void> _tryOpenResetPassword() async {
    if (!mounted) return;
    final authRepository = context.read<AuthRepository>();

    if (!authRepository.hasVerifiedResetCode) {
      await PasswordResetDeepLinkHandler.tryConsumeLatestLink(authRepository);
    }

    if (!mounted || !authRepository.hasVerifiedResetCode) return;

    await PasswordResetDeepLinkHandler.presentPasswordResetFlow(authRepository);
  }

  void _startTimer() {
    _resendSeconds = _resendDuration;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  bool get _canResend => _resendSeconds == 0 && !_isResending;

  String _resendText(AppLocalizations l10n) {
    if (_canResend) return l10n.resendCode;
    final minutes = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSeconds % 60).toString().padLeft(2, '0');
    return l10n.resendCodeIn('$minutes:$seconds');
  }

  Future<void> _resendLink() async {
    if (!_canResend) return;

    final l10n = context.l10n;
    final authRepository = context.read<AuthRepository>();

    setState(() => _isResending = true);
    try {
      await authRepository.sendPasswordResetEmail(widget.email);
      _startTimer();
      if (mounted) {
        SnackbarHelper.showSuccess(context, l10n.verificationEmailSent);
      }
    } catch (error) {
      if (mounted) {
        SnackbarHelper.showError(
          context,
          AuthExceptionHandler.getMessage(error, l10n),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: const AuthAppBar(showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceLg),
              const AuthIllustration(imagePath: AppAssets.checkEmail),
              SizedBox(height: AppSizes.spaceMd),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AuthHeader(
                  title: l10n.checkYourEmail,
                  subtitle: l10n.otpSentTo(widget.maskedEmail),
                ),
              ),
              SizedBox(height: AppSizes.h(12)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.w(12)),
                child: Text(
                  l10n.checkResetEmailInstructions,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spaceLg * 2),
              GestureDetector(
                onTap: _canResend ? _resendLink : null,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: AppSizes.sp(14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: l10n.didntReceiveCode),
                      TextSpan(
                        text: _resendText(l10n),
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontWeight: FontWeight.w700,
                          color: _canResend
                              ? AppColors.primaryColor
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spaceXl),
            ],
          ),
        ),
      ),
    );
  }
}
