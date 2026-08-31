import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/create_account_view_model.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key, required this.onAccountCreated});

  final VoidCallback onAccountCreated;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<CreateAccountViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: const AuthAppBar(showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceSm),
              AuthHeader(
                imagePath: AppAssets.splashBird,
                title: l10n.createAccount,
                subtitle: l10n.createAccountSubtitle,
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      label: l10n.fullName,
                      hint: l10n.enterYourName,
                      prefixIcon: Icons.person_outline,
                      controller: viewModel.fullNameController,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: l10n.emailAddress,
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      label: l10n.password,
                      hint: l10n.minEightChars,
                      prefixIcon: Icons.lock_outline,
                      isShowPrefixIcon: true,
                      controller: viewModel.passwordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                    ),
                    SizedBox(height: AppSizes.spaceLg),
                    PrimaryButton(
                      text: l10n.createAccountButton,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          final created = await viewModel.createAccount(
                            context: context,
                            onSuccess: () {},
                          );
                          if (!context.mounted || !created) return;
                          Navigator.of(context).pop();
                          onAccountCreated();
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
                    SizedBox(height: AppSizes.spaceMd),
                    AuthFooterLink(
                      prefix: l10n.alreadyHaveAccount,
                      actionText: l10n.signIn,
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
