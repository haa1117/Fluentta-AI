import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

class AccountDetailTile extends StatelessWidget {
  final bool isDark;
  const AccountDetailTile({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.showChevron = true, required this.isDark,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.w(16),
            vertical: AppSizes.h(16),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(15),
                    fontWeight: FontWeight.w700,
                    color:isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(14),
                    fontWeight: FontWeight.w400,
                    color:isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              if (showChevron) ...[
                SizedBox(width: AppSizes.w(8)),
                Icon(
                  Icons.chevron_right_rounded,
                  color:isDark ? AppColors.textSecondaryDark : AppColors.profileSubtitleColor,
                  size: AppSizes.sp(22),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
