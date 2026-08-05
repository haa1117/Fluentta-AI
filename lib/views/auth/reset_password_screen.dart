import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/reset_password_view_model.dart';
import 'package:fluentta_ai/views/auth/password_updated_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/auth/otp_input_field.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final viewModel = context.watch<ResetPasswordViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const AuthAppBar(showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceSm),
              const AuthIllustration(imagePath: AppAssets.resetPassword),
              SizedBox(height: AppSizes.spaceMd),
              const AuthHeader(
                title: 'Create a new password',
                subtitle:
                    'Choose a secure password you haven\'t used before',
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      label: 'New password',
                      hint: 'Enter new password',
                      prefixIcon: Icons.lock_outline,
                      controller: viewModel.newPasswordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: 'Confirm new password',
                      hint: 'Repeat your password',
                      prefixIcon: Icons.lock_outline,
                      controller: viewModel.confirmPasswordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: 'Update Password',
                      enabled: viewModel.isFormValid,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          await viewModel.updatePassword(() {
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => const PasswordUpdatedScreen(),
                              ),
                            );
                          });
                        } catch (e) {
                          if (context.mounted) {
                            SnackbarHelper.showError(
                              context,
                              viewModel.getErrorMessage(e),
                            );
                          }
                        }
                      },
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
