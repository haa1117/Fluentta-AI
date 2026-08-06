import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

class ProfileTabScreen extends StatelessWidget {
  const ProfileTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final authViewModel = context.watch<AuthViewModel>();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: AppSizes.spaceXl),
            Container(
              width: AppSizes.w(88),
              height: AppSizes.w(88),
              decoration: BoxDecoration(
                color: AppColors.homeCardLavender,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: AppColors.primaryColor,
                size: AppSizes.w(44),
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
            Text(
              authViewModel.displayName ?? 'User',
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(22),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            if (authViewModel.email != null) ...[
              SizedBox(height: AppSizes.spaceSm),
              Text(
                authViewModel.email!,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            SizedBox(height: AppSizes.spaceXl),
            _ProfileTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: authViewModel.selectedLanguage?.toUpperCase() ?? 'UR',
            ),
            SizedBox(height: AppSizes.spaceSm),
            _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App preferences',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => authViewModel.signOut(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  side: const BorderSide(color: AppColors.primaryColor),
                  padding: EdgeInsets.symmetric(vertical: AppSizes.h(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                ),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceLg),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.w(44),
            height: AppSizes.w(44),
            decoration: BoxDecoration(
              color: AppColors.homeCardLavender,
              borderRadius: BorderRadius.circular(AppSizes.w(12)),
            ),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          SizedBox(width: AppSizes.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(12),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
