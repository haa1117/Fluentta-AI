import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/viewmodels/forgot_password_view_model.dart';
import 'package:fluentta_ai/viewmodels/verify_otp_view_model.dart';
import 'package:fluentta_ai/views/auth/verify_otp_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<ForgotPasswordViewModel>();
    final authRepository = context.read<AuthRepository>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AuthAppBar(showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceLg),
              const AuthIllustration(imagePath: AppAssets.forgotPassword),
              SizedBox(height: AppSizes.spaceMd),
              AuthHeader(
                title: l10n.forgotPasswordTitle,
                subtitle: l10n.forgotPasswordSubtitle,
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      label: l10n.emailAddress,
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: l10n.sendVerificationCode,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          await viewModel.sendVerificationCode(() {
                            if (!context.mounted) return;
                            SnackbarHelper.showSuccess(
                              context,
                              l10n.verificationEmailSent,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ChangeNotifierProvider(
                                  create: (_) => VerifyOtpViewModel(
                                    authRepository: authRepository,
                                    email: viewModel.email,
                                    maskedEmail: viewModel.maskedEmail,
                                  )..initTimer(),
                                  child: const VerifyOtpScreen(),
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
              SizedBox(height: AppSizes.spaceLg * 4),
              AuthFooterLink(
                prefix: l10n.rememberPassword,
                actionText: l10n.signIn,
                onTap: () => Navigator.of(context).pop(),
              ),
              SizedBox(height: AppSizes.spaceXl),
            ],
          ),
        ),
      ),
    );
  }
}
