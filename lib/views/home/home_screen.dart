import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Fluenta',
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(18),
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => authViewModel.signOut(),
            child: Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(14),
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Fluenta!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.fontHeadline,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (authViewModel.displayName != null &&
                  authViewModel.displayName!.isNotEmpty) ...[
                SizedBox(height: AppSizes.spaceSm),
                Text(
                  authViewModel.displayName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              if (authViewModel.email != null) ...[
                SizedBox(height: AppSizes.spaceXs),
                Text(
                  authViewModel.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
              if (authViewModel.selectedLanguage != null) ...[
                SizedBox(height: AppSizes.spaceSm),
                Text(
                  'Language: ${authViewModel.selectedLanguage!.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(13),
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
