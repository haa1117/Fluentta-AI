import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:fluentta_ai/viewmodels/update_name_view_model.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';
import 'package:fluentta_ai/widgets/common/primary_button.dart';
import 'package:provider/provider.dart';

class UpdateNameScreen extends StatelessWidget {
  const UpdateNameScreen({super.key, this.initialName});

  final String? initialName;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (_) => UpdateNameViewModel(
        context.read<AuthRepository>(),
        initialName,
      ),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: AuthAppBar(
          showBack: true,
          title: l10n.nameLabel,
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
                        l10n.yourNameTitle,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(24),
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSizes.h(2)),
                      Text(
                        l10n.manageYourName,
                        style: TextStyle(
                          fontFamily: AppFonts.plusJakartaSans,
                          fontSize: AppSizes.sp(14),
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.spaceLg),
                      Consumer<UpdateNameViewModel>(
                        builder: (context, viewModel, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthTextField(
                                isDark: isDark,
                                label: l10n.firstName,
                                hint: l10n.firstName,
                                controller: viewModel.firstNameController,
                                isShowPrefixIcon: false,
                              ),
                              SizedBox(height: AppSizes.spaceMd),
                              AuthTextField(
                                label: l10n.lastName,
                                hint: l10n.lastName,
                                controller: viewModel.lastNameController,
                                isShowPrefixIcon: false, isDark: isDark,
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
                child: Consumer<UpdateNameViewModel>(
                  builder: (context, viewModel, _) {
                    return PrimaryButton(
                      text: l10n.saveChanges,
                      enabled: viewModel.isFormValid,
                      isLoading: viewModel.isLoading,
                      onPressed: () async {
                        try {
                          await viewModel.save(() async {
                            if (!context.mounted) return;
                            await context.read<AuthViewModel>().refreshProfile();
                            if (!context.mounted) return;
                            SnackbarHelper.showSuccess(
                              context,
                              l10n.nameUpdated,
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
