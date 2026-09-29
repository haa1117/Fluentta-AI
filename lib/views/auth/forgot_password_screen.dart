import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/forgot_password_view_model.dart';
import 'package:fluentta_ai/views/auth/check_reset_email_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<ForgotPasswordViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('reset_password_request');
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
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
                subtitle: l10n.forgotPasswordSubtitle, isDark: isDark
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
                                builder: (_) => CheckResetEmailScreen(
                                  email: viewModel.email,
                                  maskedEmail: viewModel.maskedEmail,
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
                actionText: l10n.signInLink,
                isDark: isDark,
                onTap: () {
                  AnalyticsService.instance.log(
                    AnalyticsEvents.resetSigninClicked,
                    {
                      AnalyticsParams.sourceScreen: 'reset_password_request',
                      AnalyticsParams.destinationScreen: 'login_email',
                    },
                  );
                  Navigator.of(context).pop();
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
