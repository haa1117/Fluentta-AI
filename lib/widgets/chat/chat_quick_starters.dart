import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// Row of tappable prompt chips shown under the greeting before the learner
/// has typed anything.
class ChatQuickStarters extends StatelessWidget {
  const ChatQuickStarters({
    super.key,
    required this.labels,
    required this.onSelected,
  });

  final List<String> labels;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.w(52), top: AppSizes.h(16)),
      child: Wrap(
        spacing: AppSizes.w(8),
        runSpacing: AppSizes.h(8),
        children: [
          for (final label in labels)
            GestureDetector(
              onTap: () => onSelected(label),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.w(16),
                  vertical: AppSizes.h(9),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.brandDarkSoftColor
                      : AppColors.brandLightSoftColor,
                  borderRadius: BorderRadius.circular(AppSizes.w(999)),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDarkColor
                        : AppColors.borderLight,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.plusJakartaSans,
                    fontSize: AppSizes.sp(12),
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.primaryBlueColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
