import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/views/profile/account_email_screen.dart';
import 'package:fluentta_ai/views/profile/update_name_screen.dart';
import 'package:fluentta_ai/views/profile/update_password_screen.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/profile/account_detail_tile.dart';
import 'package:fluentta_ai/widgets/profile/profile_section_header.dart';
import 'package:provider/provider.dart';

class AccountAndSecurityScreen extends StatefulWidget {
  const AccountAndSecurityScreen({super.key});

  @override
  State<AccountAndSecurityScreen> createState() =>
      _AccountAndSecurityScreenState();
}

class _AccountAndSecurityScreenState extends State<AccountAndSecurityScreen> {
  bool _loggedViewed = false;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final auth = context.watch<AuthViewModel>();
    final authRepository = context.read<AuthRepository>();

    final displayName = auth.displayName?.trim().isNotEmpty == true
        ? auth.displayName!.trim()
        : '—';
    final email = auth.email ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_loggedViewed) {
      _loggedViewed = true;
      AnalyticsService.instance.logScreenView('account_and_security');
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AuthAppBar(
        showBack: true,
        title: l10n.accountAndSecurity,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.spaceMd),
              Text(
                l10n.manageAccount,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(24),
                  fontWeight: FontWeight.w700,
                  color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(2)),
              Text(
                l10n.manageAccountDesc,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                  color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.h(24)),
              ProfileSectionHeader(title: l10n.personalDetails, isDark: isDark),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:isDark ? AppColors.surfaceBgDarkColor : AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  border: Border.all(color:isDark ? AppColors.borderDarkColor : AppColors.borderLight),
                ),
                child: Column(
                  children: [
                    AccountDetailTile(
                      isDark: isDark,

                      label: l10n.nameLabel,
                      value: displayName,
                      onTap: () async {
                        AnalyticsService.instance.log(
                          AnalyticsEvents.accountFieldClicked,
                          {
                            AnalyticsParams.field: 'name',
                            AnalyticsParams.destinationScreen: 'update_name',
                          },
                        );
                        await Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => UpdateNameScreen(
                              initialName: auth.displayName,
                            ),
                          ),
                        );
                        if (context.mounted) {
                          await context.read<AuthViewModel>().refreshProfile();
                        }
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color:isDark ? AppColors.borderDarkColor : AppColors.borderLight.withValues(alpha: 0.5),
                    ),
                    AccountDetailTile(
                      isDark: isDark,
                      label: l10n.emailLabel,
                      value: email,
                      onTap: () {
                        AnalyticsService.instance.log(
                          AnalyticsEvents.accountFieldClicked,
                          {
                            AnalyticsParams.field: 'email',
                            AnalyticsParams.destinationScreen: 'account_email',
                          },
                        );
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => AccountEmailScreen(email: email),
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color:isDark ? AppColors.borderDarkColor : AppColors.borderLight.withValues(alpha: 0.5),
                    ),
                    AccountDetailTile(
                      isDark: isDark,

                      label: l10n.passwordLabel,
                      value: l10n.passwordMasked,
                      onTap: () {
                        AnalyticsService.instance.log(
                          AnalyticsEvents.accountFieldClicked,
                          {
                            AnalyticsParams.field: 'password',
                            AnalyticsParams.destinationScreen:
                                'update_password',
                          },
                        );
                        if (!authRepository.canChangePassword) {
                          // Social sign-in accounts have no password to
                          // change; we can't tell which provider from here,
                          // so auth_method reports the broad category.
                          AnalyticsService.instance.log(
                            AnalyticsEvents.passwordChangeUnavailableShown,
                            {AnalyticsParams.authMethod: 'social'},
                          );
                          SnackbarHelper.showError(
                            context,
                            l10n.passwordChangeUnavailable,
                          );
                          return;
                        }
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => const UpdatePasswordScreen(),
                          ),
                        );
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
