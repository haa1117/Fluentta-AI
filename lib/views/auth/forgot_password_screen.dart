import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/forgot_password_view_model.dart';
import 'package:fluentta_ai/viewmodels/verify_otp_view_model.dart';
import 'package:fluentta_ai/views/auth/verify_otp_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/auth/otp_input_field.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<ForgotPasswordViewModel>();

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
              const AuthHeader(
                title: 'Forgot your password?',
                subtitle:
                    'Enter the email linked to your account.\n We\'ll send you a verification code.',
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      label: 'Email address',
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: 'Send Verification Code',
                      isLoading: viewModel.isLoading,
                      onPressed: () => viewModel.sendVerificationCode(() {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => VerifyOtpViewModel(
                                maskedEmail: viewModel.maskedEmail,
                              )..initTimer(),
                              child: const VerifyOtpScreen(),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceLg * 4),
              AuthFooterLink(
                prefix: 'Remember your password? ',
                actionText: 'Sign in',
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
