import 'package:flutter/material.dart';
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

class AccountAndSecurityScreen extends StatelessWidget {
  const AccountAndSecurityScreen({super.key});

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
                        if (!authRepository.canChangePassword) {
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
