import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';
import 'package:fluentta_ai/viewmodels/open_chat_view_model.dart';

/// Pill-shaped segmented control that switches between the text and voice
/// input surfaces. The active segment uses the brand gradient.
class ChatModeToggle extends StatelessWidget {
  const ChatModeToggle({
    super.key,
    required this.mode,
    required this.onChanged,
    required this.textLabel,
    required this.voiceLabel,
  });

  final ChatInputMode mode;
  final ValueChanged<ChatInputMode> onChanged;
  final String textLabel;
  final String voiceLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: AppSizes.h(50),
      padding: EdgeInsets.all(AppSizes.w(4)),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.brandDarkSoftColor
            : AppColors.brandLightSoftColor,
        borderRadius: BorderRadius.circular(AppSizes.w(999)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Segment(
              label: textLabel,
              selected: mode == ChatInputMode.text,
              onTap: () => onChanged(ChatInputMode.text),
            ),
          ),
          Expanded(
            child: _Segment(
              label: voiceLabel,
              selected: mode == ChatInputMode.voice,
              onTap: () => onChanged(ChatInputMode.voice),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: AppSizes.h(8)),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGradientStart,
                    AppColors.primaryGradientEnd,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(AppSizes.w(999)),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.plusJakartaSans,
            fontSize: AppSizes.sp(16),
            fontWeight: FontWeight.w600,
            color: selected
                ? AppColors.white
                : (isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
