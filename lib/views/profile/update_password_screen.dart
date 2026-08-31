import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/viewmodels/update_password_view_model.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return ChangeNotifierProvider(
      create: (_) => UpdatePasswordViewModel(context.read<AuthRepository>()),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: AuthAppBar(
          showBack: true,
          title: l10n.passwordLabel,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.horizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSizes.spaceMd),
                      Text(
                        l10n.changePasswordTitle,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(24),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.h(2)),
                      Text(
                        l10n.changePasswordSubtitle,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.spaceLg),
                      Consumer<UpdatePasswordViewModel>(
                        builder: (context, viewModel, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthTextField(
                                label: l10n.currentPassword,
                                hint: l10n.enterCurrentPassword,
                                controller:
                                    viewModel.currentPasswordController,
                                obscureText: true,
                                showVisibilityToggle: true,
                                isShowPrefixIcon: false,
                              ),
                              SizedBox(height: AppSizes.spaceMd),
                              AuthTextField(
                                label: l10n.newPassword,
                                hint: l10n.enterNewPassword,
                                controller: viewModel.newPasswordController,
                                obscureText: true,
                                showVisibilityToggle: true,
                                isShowPrefixIcon: false,
                              ),
                              SizedBox(height: AppSizes.spaceMd),
                              AuthTextField(
                                label: l10n.confirmNewPassword,
                                hint: l10n.repeatPassword,
                                controller:
                                    viewModel.confirmPasswordController,
                                obscureText: true,
                                showVisibilityToggle: true,
                                isShowPrefixIcon: false,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.horizontalPadding,
                  AppSizes.spaceMd,
                  AppSizes.horizontalPadding,
                  AppSizes.spaceLg,
                ),
                child: Consumer<UpdatePasswordViewModel>(
                  builder: (context, viewModel, _) {
                    return PrimaryButton(
                      text: l10n.saveChanges,
                      enabled: viewModel.isFormValid,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          await viewModel.save(() {
                            if (!context.mounted) return;
                            SnackbarHelper.showSuccess(
                              context,
                              l10n.passwordUpdatedSuccess,
                            );
                            Navigator.of(context).pop();
                          });
                        } catch (error) {
                          if (context.mounted) {
                            SnackbarHelper.showError(
                              context,
                              viewModel.getErrorMessage(error, l10n),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
