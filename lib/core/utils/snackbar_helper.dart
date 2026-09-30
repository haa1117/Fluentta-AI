import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/haptics/haptic_service.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// In-app Fluenta toast (card + border). Never uses Material [SnackBar].
class SnackbarHelper {
  SnackbarHelper._();

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void showError(BuildContext context, String message) {
    _show(context, message: message, isError: true);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message: message, isError: false);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required bool isError,
  }) {
    if (!context.mounted) return;
    HapticService.medium();

    OverlayState? overlay;
    try {
      overlay = Overlay.of(context, rootOverlay: true);
    } catch (_) {
      overlay = null;
    }
    if (overlay == null) return;

    _timer?.cancel();
    _entry?.remove();

    _entry = OverlayEntry(
      builder: (overlayContext) {
        AppSizes.init(overlayContext);
        final isDark = Theme.of(overlayContext).brightness == Brightness.dark;
        final surface =
            isDark ? AppColors.surfaceBgDarkColor : AppColors.white;
        final border =
            isDark ? AppColors.borderDarkColor : AppColors.borderLight;
        final textColor =
            isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
        final accent = isError ? Colors.red.shade600 : AppColors.primaryColor;
        final bottom = MediaQuery.paddingOf(overlayContext).bottom + 24;

        return Positioned(
          left: AppSizes.w(16),
          right: AppSizes.w(16),
          bottom: bottom,
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.w(4),
                    AppSizes.h(14),
                    AppSizes.w(16),
                    AppSizes.h(14),
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(AppSizes.w(16)),
                    border: Border.all(color: border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4,
                        height: AppSizes.h(36),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      SizedBox(width: AppSizes.w(12)),
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                            fontFamily: AppFonts.plusJakartaSans,
                            fontSize: AppSizes.sp(14),
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_entry!);
    _timer = Timer(const Duration(seconds: 3), () {
      _entry?.remove();
      _entry = null;
    });
  }
}
