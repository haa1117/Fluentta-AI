import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/constants/app_fonts.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/navigation/root_navigator_key.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// Full-screen blocker shown while an interstitial or rewarded ad loads.
class AdLoadingOverlay {
  AdLoadingOverlay._();

  static OverlayEntry? _entry;

  static void show() {
    hide();
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (context) {
        final l10n = context.l10n;
        return AbsorbPointer(
          child: Material(
            color: Colors.black.withValues(alpha: 0.72),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.loadingAd.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: AppFonts.plusJakartaSans,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
