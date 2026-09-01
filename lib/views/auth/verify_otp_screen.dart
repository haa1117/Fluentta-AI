import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/viewmodels/reset_password_view_model.dart';
import 'package:fluentta_ai/viewmodels/verify_otp_view_model.dart';
import 'package:fluentta_ai/views/auth/reset_password_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/auth/otp_input_field.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<VerifyOtpViewModel>();
    final authRepository = context.read<AuthRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  subtitle: l10n.otpSentTo(viewModel.maskedEmail), isDark: isDark,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg * 2),
              AuthCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OtpInputField(
                      length: VerifyOtpViewModel.otpLength,
                      onChanged: viewModel.updateOtp,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: l10n.verifyCode,
                      enabled: viewModel.isCodeComplete,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          await viewModel.verifyCode(() {
                            if (!context.mounted) return;
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => ResetPasswordViewModel(
                                    authRepository,
                                  ),
                                  child: const ResetPasswordScreen(),
                                ),
                              ),
                            );
                          });
                        } catch (e) {
                          if (context.mounted) {
                            SnackbarHelper.showError(
                              context,
                              viewModel.getErrorMessage(e, l10n),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              GestureDetector(
                onTap: viewModel.canResend
                    ? () async {
                        try {
                          await viewModel.resendCode();
                          if (context.mounted) {
                            SnackbarHelper.showSuccess(
                              context,
                              l10n.verificationCodeResent,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            SnackbarHelper.showError(
                              context,
                              viewModel.getErrorMessage(e, l10n),
                            );
                          }
                        }
                      }
                    : null,
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
                        text: viewModel.resendText(l10n),
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontWeight: FontWeight.w700,
                          color: viewModel.canResend
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
