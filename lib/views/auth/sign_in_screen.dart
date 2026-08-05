import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/create_account_view_model.dart';
import 'package:fluentta_ai/viewmodels/forgot_password_view_model.dart';
import 'package:fluentta_ai/viewmodels/sign_in_view_model.dart';
import 'package:fluentta_ai/views/auth/create_account_screen.dart';
import 'package:fluentta_ai/views/auth/forgot_password_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/auth/social_login_button.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<SignInViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceMd),
              AuthHeader(
                imagePath: AppAssets.authBird,
                title: 'Sign in with Email',
                subtitle: 'Continue your English learning journey.',
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
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: 'Password',
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      controller: viewModel.passwordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => ChangeNotifierProvider(
                                create: (_) => ForgotPasswordViewModel(),
                                child: const ForgotPasswordScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(13),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    PrimaryButton(
                      text: 'Sign In',
                      isLoading: viewModel.isLoading,
                      loadingText: 'Signing in...',
                      onPressed: () => viewModel.signIn(
                        context: context,
                        onSuccess: onSuccess,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    const OrDivider(),
                    SizedBox(height: AppSizes.spaceMd),
                    SocialLoginButton(
                      type: SocialLoginType.google,
                      onPressed: () =>
                          viewModel.signInWithGoogle(onSuccess),
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    SocialLoginButton(
                      type: SocialLoginType.apple,
                      onPressed: () => viewModel.signInWithApple(onSuccess),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthFooterLink(
                prefix: 'New to Fluenta? ',
                actionText: 'Create account',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => CreateAccountViewModel(),
                        child: CreateAccountScreen(onSuccess: onSuccess),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppSizes.spaceXl),
            ],
          ),
        ),
      ),
    );
  }
}
