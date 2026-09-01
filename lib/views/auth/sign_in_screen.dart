import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
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
  const SignInScreen({
    super.key,
    required this.onSuccess,
    required this.onAccountCreated,
  });

  final Future<void> Function() onSuccess;
  final VoidCallback onAccountCreated;

  Future<void> _handleAuthAction(
    BuildContext context,
    Future<bool> Function() action,
    SignInViewModel viewModel,
  ) async {
    final l10n = context.l10n;
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showError(context, viewModel.getErrorMessage(e, l10n));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<SignInViewModel>();
    final authRepository = context.read<AuthRepository>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceMd),
              AuthHeader(
                imagePath: AppAssets.authBird,
                title: l10n.signInWithEmail,
                subtitle: l10n.signInSubtitle, isDark: isDark,
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      isDark: isDark,

                      label: l10n.emailAddress,
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      isDark: isDark,

                      label: l10n.password,
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
                                create: (_) => ForgotPasswordViewModel(
                                  authRepository,
                                ),
                                child: const ForgotPasswordScreen(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          l10n.forgotPassword,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(13),
                            fontWeight: FontWeight.w600,
                            color:isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    PrimaryButton(
                      text: l10n.signIn,
                      isLoading: viewModel.isLoading,
                      loadingText: l10n.signIn,
                      onPressed: () => _handleAuthAction(
                        context,
                        () => viewModel.signIn(onSuccess: onSuccess),
                        viewModel,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                     OrDivider(isDark: isDark),
                    SizedBox(height: AppSizes.spaceMd),
                    SocialLoginButton(
                      isDark: isDark,
                      type: SocialLoginType.google,
                      onPressed: () => _handleAuthAction(
                        context,
                        () => viewModel.signInWithGoogle(
                          onSuccess: onSuccess,
                          onNewUser: onAccountCreated,
                        ),
                        viewModel,
                      ),
                    ),
                    SizedBox(height: AppSizes.spaceSm),
                    SocialLoginButton(
                      type: SocialLoginType.apple,
                      onPressed: () => _handleAuthAction(
                        context,
                        () => viewModel.signInWithApple(
                          onSuccess: onSuccess,
                          onNewUser: onAccountCreated,
                        ),
                        viewModel,
                      ), isDark: isDark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthFooterLink(
                prefix: l10n.newToFluenta,
                actionText: l10n.createAccount,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ChangeNotifierProvider(
                        create: (_) => CreateAccountViewModel(authRepository),
                        child: CreateAccountScreen(
                          onAccountCreated: onAccountCreated,
                        ),
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
