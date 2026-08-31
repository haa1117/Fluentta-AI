import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_appearance_mode.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/theme/theme_view_model.dart';
import 'package:provider/provider.dart';

Future<void> showAppAppearanceSheet(BuildContext context) {
  AppSizes.init(context);

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: const _AppAppearanceSheet(),
      );
    },
  );
}

class _AppAppearanceSheet extends StatelessWidget {
  const _AppAppearanceSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final themeViewModel = context.watch<ThemeViewModel>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.sp(24)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.horizontalPadding,
        AppSizes.h(12),
        AppSizes.horizontalPadding,
        AppSizes.h(24),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.w(40),
              height: AppSizes.h(4),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(AppSizes.w(2)),
              ),
            ),
            SizedBox(height: AppSizes.h(16)),
            Text(
              l10n.appAppearance,
              style: TextStyle(
                fontFamily: AppFonts.plusJakartaSans,
                fontSize: AppSizes.sp(18),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSizes.h(16)),
            _AppearanceOptionTile(
              label: l10n.systemDefault,
              isSelected: themeViewModel.mode == AppAppearanceMode.system,
              onTap: () => themeViewModel.setMode(AppAppearanceMode.system),
            ),
            _AppearanceOptionTile(
              label: l10n.lightMode,
              isSelected: themeViewModel.mode == AppAppearanceMode.light,
              onTap: () => themeViewModel.setMode(AppAppearanceMode.light),
            ),
            _AppearanceOptionTile(
              label: l10n.darkMode,
              isSelected: themeViewModel.mode == AppAppearanceMode.dark,
              onTap: () => themeViewModel.setMode(AppAppearanceMode.dark),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppearanceOptionTile extends StatelessWidget {
  const _AppearanceOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(4),
            vertical: AppSizes.h(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: isSelected
                    ? AppColors.primarySecondaryColor
                    : AppColors.radioUnselected,
                size: AppSizes.sp(22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
