import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<MainShellViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color:isDark ? Color(0xff100D17): AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(12),
            vertical: AppSizes.h(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                svgIcon: AppAssets.homeIcon,
                label: l10n.navHome,
                isSelected: viewModel.currentTab == MainTab.home,
                onTap: () => viewModel.selectTab(MainTab.home),
              ),
              _NavItem(
                svgIcon: AppAssets.learnIcon,
                label: l10n.navLearn,
                isSelected: viewModel.currentTab == MainTab.learn,
                onTap: () => viewModel.selectTab(MainTab.learn),
              ),
              _NavItem(
                svgIcon: AppAssets.rolePlayIcon,
                label: l10n.navSpeak,
                isSelected: viewModel.currentTab == MainTab.speak,
                onTap: () => viewModel.selectTab(MainTab.speak),
              ),
              _NavItem(
                svgIcon: AppAssets.profileIcon,
                label: l10n.navProfile,
                isSelected: viewModel.currentTab == MainTab.profile,
                onTap: () {
                  viewModel.selectTab(MainTab.profile);
                  context.read<ProfileViewModel>().refreshStats();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.svgIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String svgIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(16),
            vertical: AppSizes.h(8),
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(AppSizes.w(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgIcon,
                width: AppSizes.sp(16),
                height: AppSizes.sp(16),
                color: isSelected ? AppColors.white:Colors.red,
              ),
              SizedBox(height: AppSizes.h(2)),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(11),
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgIcon,
            width: AppSizes.sp(16),
            height: AppSizes.sp(16),
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontWeight: FontWeight.w500,
              color: AppColors.navInactive,
            ),
          ),
        ],
      ),
    );
  }
}
