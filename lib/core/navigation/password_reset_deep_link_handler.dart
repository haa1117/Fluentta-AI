import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/navigation/root_navigator_key.dart';
import 'package:fluentta_ai/core/utils/password_reset_link_parser.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/viewmodels/reset_password_view_model.dart';
import 'package:fluentta_ai/views/auth/reset_password_screen.dart';
import 'package:provider/provider.dart';

class PasswordResetDeepLinkHandler {
  PasswordResetDeepLinkHandler._();

  static bool _isNavigating = false;
  static bool _hasPresentedResetFlow = false;
  static final AppLinks _appLinks = AppLinks();

  static Future<bool> handleUri(Uri uri, AuthRepository authRepository) async {
    final linkData = PasswordResetLinkParser.parse(uri);
    if (linkData == null) {
      if (kDebugMode) {
        debugPrint('Password reset link could not be parsed: $uri');
      }
      return false;
    }

    if (kDebugMode) {
      debugPrint('Password reset link parsed oobCode=${linkData.oobCode}');
    }

    await authRepository.handlePasswordResetLink(oobCode: linkData.oobCode);
    return true;
  }

  /// Reads the latest deep link after the app returns from background.
  static Future<bool> tryConsumeLatestLink(
    AuthRepository authRepository,
  ) async {
    try {
      final uri = await _appLinks.getLatestLink();
      if (uri == null) return false;

      if (kDebugMode) {
        debugPrint('Consuming latest password reset link: $uri');
      }

      return handleUri(uri, authRepository);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('tryConsumeLatestLink failed: $error');
      }
      return false;
    }
  }

  /// Clears forgot-password routes and opens the reset-password screen.
  static Future<void> presentPasswordResetFlow(
    AuthRepository authRepository,
  ) async {
    if (!authRepository.hasVerifiedResetCode) {
      _hasPresentedResetFlow = false;
      return;
    }
    if (_isNavigating || _hasPresentedResetFlow) return;

    _isNavigating = true;
    try {
      authRepository.markDirectPasswordResetLaunch();

      for (var attempt = 0; attempt < 50; attempt++) {
        final navigator = rootNavigatorKey.currentState;
        if (navigator != null) {
          if (navigator.canPop()) {
            navigator.pushAndRemoveUntil<void>(
              MaterialPageRoute<void>(
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => ResetPasswordViewModel(authRepository),
                  child: ResetPasswordScreen(
                    isDeepLinkFlow: true,
                    onFlowComplete: () {
                      authRepository.completePasswordResetFlow();
                      _hasPresentedResetFlow = false;
                    },
                  ),
                ),
              ),
              (route) => route.isFirst,
            );
          } else {
            authRepository.passwordResetSignal.value++;
          }
          _hasPresentedResetFlow = true;
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }

      authRepository.passwordResetSignal.value++;
      _hasPresentedResetFlow = true;
    } finally {
      _isNavigating = false;
    }
  }
}
