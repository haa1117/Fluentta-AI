import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

typedef CefrLevelLabelBuilder = String Function(
  AppLocalizations l10n,
  CefrLevel level,
);

typedef CefrLevelLockedTapHandler = void Function(
  BuildContext context,
  CefrLevel level,
);

class CefrLevelBar extends StatelessWidget {
  const CefrLevelBar({
    super.key,
    required this.totalXp,
    required this.selectedLevel,
    required this.onLevelSelected,
    this.levels = CefrLevelProgress.tabLevels,
    this.isLevelUnlocked,
    this.onLockedLevelTap,
    this.labelBuilder,
    this.tabSpacing,
    this.tabHorizontalPadding,
    this.tabVerticalPadding,
    this.tabBorderRadius,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.showLockIcon = true,
  });

  final int totalXp;
  final CefrLevel selectedLevel;
  final ValueChanged<CefrLevel> onLevelSelected;
  final List<CefrLevel> levels;
  final bool Function(CefrLevel level)? isLevelUnlocked;
  final CefrLevelLockedTapHandler? onLockedLevelTap;
  final CefrLevelLabelBuilder? labelBuilder;
  final double? tabSpacing;
  final double? tabHorizontalPadding;
  final double? tabVerticalPadding;
  final double? tabBorderRadius;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final bool showLockIcon;

  bool _levelUnlocked(CefrLevel level) {
    return isLevelUnlocked?.call(level) ??
        CefrLevelProgress.isLevelUnlocked(totalXp, level);
  }

  String _label(AppLocalizations l10n, CefrLevel level) {
    return labelBuilder?.call(l10n, level) ??
        CefrLevelProgress.levelCodeLabel(l10n, level);
  }

  void _onLockedTap(BuildContext context, CefrLevel level) {
    if (onLockedLevelTap != null) {
      onLockedLevelTap!(context, level);
      return;
    }
    SnackbarHelper.showSuccess(
      context,
      context.l10n.roleplayLevelLocked(CefrLevelProgress.xpRequiredFor(level)),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final level in levels) ...[
            CefrLevelTab(
              label: _label(l10n, level),
              selected: level == selectedLevel,
              locked: !_levelUnlocked(level),
              showLockIcon: showLockIcon,
              horizontalPadding: tabHorizontalPadding,
              verticalPadding: tabVerticalPadding,
              borderRadius: tabBorderRadius,
              selectedBackgroundColor: selectedBackgroundColor,
              unselectedBackgroundColor: unselectedBackgroundColor,
              onTap: () {
                if (!_levelUnlocked(level)) {
                  _onLockedTap(context, level);
                  return;
                }
                onLevelSelected(level);
              },
            ),
            SizedBox(width: tabSpacing ?? AppSizes.w(8)),
          ],
        ],
      ),
    );
  }
}

class CefrLevelTab extends StatelessWidget {
  const CefrLevelTab({
    super.key,
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
    this.showLockIcon = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderRadius,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
  });

  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;
  final bool showLockIcon;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? borderRadius;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    final background = selected
        ? (selectedBackgroundColor ?? AppColors.primaryColor)
        : (unselectedBackgroundColor ?? const Color(0xffF3E8FF));
    final textColor = selected
        ? AppColors.white
        : locked
            ? AppColors.inActiveTextColo
            : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.w(24),
        ),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? AppSizes.w(20),
            vertical: verticalPadding ?? AppSizes.h(5),
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppSizes.w(24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLockIcon && locked) ...[
                Icon(
                  Icons.lock_rounded,
                  size: AppSizes.sp(14),
                  color: textColor,
                ),
                SizedBox(width: AppSizes.w(4)),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.plusJakartaSans,
                  fontSize: AppSizes.sp(14),
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
