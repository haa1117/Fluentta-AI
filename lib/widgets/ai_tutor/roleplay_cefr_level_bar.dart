import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_cefr_progress.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';

class RoleplayCefrLevelBar extends StatelessWidget {
  const RoleplayCefrLevelBar({
    super.key,
    required this.totalXp,
    required this.selectedLevel,
    required this.onLevelSelected,
  });

  final int totalXp;
  final CefrLevel selectedLevel;
  final ValueChanged<CefrLevel> onLevelSelected;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);
    final l10n = context.l10n;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final level in RoleplayCefrProgress.tabLevels) ...[
            _LevelTab(
              label: RoleplayCefrProgress.levelCodeLabel(l10n, level),
              selected: level == selectedLevel,
              locked: !RoleplayCefrProgress.isLevelUnlocked(totalXp, level),
              onTap: () {
                if (!RoleplayCefrProgress.isLevelUnlocked(totalXp, level)) {
                  SnackbarHelper.showSuccess(
                    context,
                    l10n.roleplayLevelLocked(
                      RoleplayCefrProgress.xpRequiredFor(level),
                    ),
                  );
                  return;
                }
                onLevelSelected(level);
              },
            ),
            SizedBox(width: AppSizes.w(8)),
          ],
        ],
      ),
    );
  }
}

class _LevelTab extends StatelessWidget {
  const _LevelTab({
    required this.label,
    required this.selected,
    required this.locked,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool locked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    final background = selected
        ? AppColors.primaryColor
        : Color(0xffF3E8FF);
    final textColor = selected
        ? AppColors.white
        : locked
            ? AppColors.inActiveTextColo
            : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.w(24)),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(20),
            vertical: AppSizes.h(5),
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppSizes.w(24)),
            // border: Border.all(
            //   color: selected
            //       ? AppColors.primaryColor
            //       : AppColors.borderLight,
            // ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (locked) ...[
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
