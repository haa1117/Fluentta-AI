import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
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

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key, required this.onAccountCreated});

  final void Function(String signupMethod) onAccountCreated;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<CreateAccountViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('signup_email');
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: const AuthAppBar(showBack: true, title: 'Fluenta'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: AppSizes.spaceSm),
              AuthHeader(
                imagePath: AppAssets.createAccountBird,
                title: l10n.createAccount,
                subtitle: l10n.createAccountSubtitle,
                isDark: isDark
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      isDark: isDark,
                      label: l10n.fullName,
                      hint: l10n.enterYourName,
                      prefixIcon: Icons.person_outline,
                      controller: viewModel.fullNameController,
                      isShowPrefixIcon: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(
                      isDark: isDark,
                      label: l10n.emailAddress,
                      hint: 'name@example.com',
                      prefixIcon: Icons.email_outlined,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                      isShowPrefixIcon: true,
                      onTap: viewModel.logStarted,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    AuthTextField(                      isDark: isDark,

                      label: l10n.password,
                      hint: l10n.minEightChars,
                      prefixIcon: Icons.lock_outline,
                      isShowPrefixIcon: true,
                      controller: viewModel.passwordController,
                      obscureText: true,
                      showVisibilityToggle: true,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
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
                          widget.onAccountCreated('email');
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
                    SizedBox(height: AppSizes.spaceLg),
                    AuthFooterLink(
                      prefix: l10n.alreadyHaveAccount,
                      actionText: l10n.signInLink,
                      isDark: isDark,
                      showTopDivider: true,
                      onTap: () {
                        AnalyticsService.instance.log(
                          AnalyticsEvents.signupLoginClicked,
                          {
                            AnalyticsParams.sourceScreen: 'signup_email',
                            AnalyticsParams.destinationScreen: 'login_email',
                          },
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )

              ),
              SizedBox(height: AppSizes.spaceXl),
            ],
          ),
        ),
      ),
    );
  }
}
