import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/create_account_view_model.dart';
import 'package:fluentta_ai/views/auth/account_created_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<CreateAccountViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AuthAppBar(showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceSm),
              AuthHeader(
                imagePath: AppAssets.splashBird,
                title: 'Create account',
                subtitle: 'Save your learning progress across devices',
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      label: 'Full Name',
                      hint: 'Enter your name',
                      prefixIcon: Icons.person_outline,
                      controller: viewModel.fullNameController,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: 'Email address',
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: 'Password',
                      hint: 'Min. 8 characters',
                      prefixIcon: Icons.lock_outline,
                      isShowPrefixIcon: true,
                      controller: viewModel.passwordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: 'Create Account',
                      isLoading: viewModel.isLoading,
                      onPressed: () => viewModel.createAccount(
                        context: context,
                        onSuccess: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => AccountCreatedScreen(
                                onContinue: onSuccess,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthFooterLink(
                      prefix: 'Already have an account? ',
                      actionText: 'Sign in',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
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
