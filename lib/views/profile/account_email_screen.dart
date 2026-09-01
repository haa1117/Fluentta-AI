import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/widgets/auth/auth_text_field.dart';
import 'package:fluentta_ai/widgets/auth/auth_widgets.dart';

class AccountEmailScreen extends StatefulWidget {
  const AccountEmailScreen({super.key, required this.email});

  final String email;

  @override
  State<AccountEmailScreen> createState() => _AccountEmailScreenState();
}

class _AccountEmailScreenState extends State<AccountEmailScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: AuthAppBar(
        showBack: true,
        title: l10n.emailScreenTitle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.spaceMd),
              Text(
                l10n.emailAddress,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(24),
                  fontWeight: FontWeight.w700,
                  color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSizes.h(8)),
              Text(
                l10n.manageYourEmailAddress,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w400,
                  color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              SizedBox(height: AppSizes.spaceLg),
              AuthCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthTextField(
                      isDark: isDark,

                      label: l10n.currentEmailAddress,
                      hint: widget.email,
                      controller: _emailController,
                      readOnly: true,
                      enabled: false,
                      prefixIcon: Icons.email_outlined,
                    ),
                    SizedBox(height: AppSizes.spaceMd),
                    Text(
                      l10n.emailCannotBeChanged,
                      style: TextStyle(
                        fontFamily: AppFonts.plusJakartaSans,
                        fontSize: AppSizes.sp(13),
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
