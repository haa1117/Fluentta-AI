import 'package:fluentta_ai/core/tutorial/tutorial_targets.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/main_shell_view_model.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Screen id (analytics) for each bottom nav destination.
String _screenIdFor(MainTab tab) => switch (tab) {
      MainTab.home => 'home',
      MainTab.learn => 'learn',
      MainTab.speak => 'role_play',
      MainTab.profile => 'profile',
    };

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;
    final viewModel = context.watch<MainShellViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentTab = viewModel.currentTab;

    void logNavTap(MainTab tab) {
      if (tab == currentTab) return;
      AnalyticsService.instance.log(AnalyticsEvents.bottomNavClicked, {
        AnalyticsParams.navItem: _screenIdFor(tab),
        AnalyticsParams.sourceScreen: _screenIdFor(currentTab),
        AnalyticsParams.destinationScreen: _screenIdFor(tab),
      });
    }

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
                isDark: isDark,
                svgIcon: AppAssets.homeIcon,
                label: l10n.navHome,
                isSelected: viewModel.currentTab == MainTab.home,
                onTap: () {
                  HapticService.selection();
                  logNavTap(MainTab.home);
                  viewModel.selectTab(MainTab.home);
                },
              ),
              _NavItem(
                isDark: isDark,

                svgIcon: AppAssets.learnIcon,
                label: l10n.navLearn,
                isSelected: viewModel.currentTab == MainTab.learn,
                onTap: () {
                  HapticService.selection();
                  logNavTap(MainTab.learn);
                  viewModel.selectTab(MainTab.learn);
                },
              ),
              _NavItem(
                isDark: isDark,

                svgIcon: AppAssets.rolePlayIcon,
                label: l10n.navSpeak,
                isSelected: viewModel.currentTab == MainTab.speak,
                onTap: () {
                  HapticService.selection();
                  logNavTap(MainTab.speak);
                  viewModel.selectTab(MainTab.speak);
                },
              ),
              _NavItem(
                key: TutorialTargets.navProfile,
                isDark: isDark,

                svgIcon: AppAssets.profileIcon,
                label: l10n.navProfile,
                isSelected: viewModel.currentTab == MainTab.profile,
                onTap: () {
                  HapticService.selection();
                  logNavTap(MainTab.profile);
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
  final bool isDark;
  const _NavItem({
    super.key,
    required this.svgIcon,
    required this.label,
    required this.isSelected,
    required this.onTap, required this.isDark,
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
                color: isSelected ? isDark ? AppColors.textPrimary : AppColors.white:Colors.red,
              ),
              SizedBox(height: AppSizes.h(2)),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(11),
                  fontWeight: FontWeight.w600,
                  color:isSelected ? isDark ? AppColors.textPrimary : AppColors.white : Colors.red
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
            color: isDark ? AppColors.textSecondaryDark :null,
          ),
          SizedBox(height: AppSizes.h(4)),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.plusJakartaSans,
              fontSize: AppSizes.sp(11),
              fontWeight: FontWeight.w500,
              color:isDark ? AppColors.textSecondaryDark : AppColors.navInactive,
            ),
          ),
        ],
      ),
    );
  }
}
