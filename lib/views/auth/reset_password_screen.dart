import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/reset_password_view_model.dart';
import 'package:fluentta_ai/views/auth/password_updated_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({
    super.key,
    this.isDeepLinkFlow = false,
    this.onFlowComplete,
  });

  final bool isDeepLinkFlow;
  final VoidCallback? onFlowComplete;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<ResetPasswordViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AuthAppBar(showBack: !isDeepLinkFlow),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceSm),
              const AuthIllustration(imagePath: AppAssets.resetPassword),
              SizedBox(height: AppSizes.spaceMd),
              AuthHeader(
                title: l10n.createNewPasswordTitle,
                subtitle: l10n.createNewPasswordSubtitle,
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      label: l10n.newPassword,
                      hint: l10n.enterNewPassword,
                      prefixIcon: Icons.lock_outline,
                      controller: viewModel.newPasswordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: l10n.confirmNewPassword,
                      hint: l10n.repeatPassword,
                      prefixIcon: Icons.lock_outline,
                      controller: viewModel.confirmPasswordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: l10n.updatePassword,
                      enabled: viewModel.isFormValid,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          await viewModel.updatePassword(() {
                            if (!context.mounted) return;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (_) => PasswordUpdatedScreen(
                                  onBackToSignIn: isDeepLinkFlow
                                      ? onFlowComplete
                                      : null,
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
              SizedBox(height: AppSizes.spaceXl),
            ],
          ),
        ),
      ),
    );
  }
}
