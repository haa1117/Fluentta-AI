import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/navigation/password_reset_deep_link_handler.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';

/// Listens for password-reset links while the app is already running.
class PasswordResetLinkListener extends StatefulWidget {
  const PasswordResetLinkListener({super.key, required this.child});

  final Widget child;

  @override
  State<PasswordResetLinkListener> createState() =>
      _PasswordResetLinkListenerState();
}

class _PasswordResetLinkListenerState extends State<PasswordResetLinkListener>
    with WidgetsBindingObserver {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  bool _isHandlingLink = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenForLinks();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleLinkOnResume();
    }
  }

  Future<void> _listenForLinks() async {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleUri,
      onError: (Object error) {
        if (kDebugMode) {
          debugPrint('PasswordResetLinkListener stream error: $error');
        }
      },
    );
  }

  Future<void> _handleLinkOnResume() async {
    if (_isHandlingLink || !mounted) return;

    final authRepository = context.read<AuthRepository>();
    if (authRepository.hasVerifiedResetCode) {
      await PasswordResetDeepLinkHandler.presentPasswordResetFlow(
        authRepository,
      );
      return;
    }

    _isHandlingLink = true;
    try {
      final handled = await PasswordResetDeepLinkHandler.tryConsumeLatestLink(
        authRepository,
      );
      if (!handled || !mounted) return;

      await PasswordResetDeepLinkHandler.presentPasswordResetFlow(
        authRepository,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('PasswordResetLinkListener resume link failed: $error');
      }
    } finally {
      _isHandlingLink = false;
    }
  }

  Future<void> _handleUri(Uri uri) async {
    if (_isHandlingLink || !mounted) return;

    if (kDebugMode) {
      debugPrint('PasswordResetLinkListener received: $uri');
    }

    _isHandlingLink = true;
    try {
      final authRepository = context.read<AuthRepository>();
      final handled = await PasswordResetDeepLinkHandler.handleUri(
        uri,
        authRepository,
      );
      if (!handled || !mounted) return;

      await PasswordResetDeepLinkHandler.presentPasswordResetFlow(
        authRepository,
      );
    } catch (error) {
      if (kDebugMode) {
        debugPrint('PasswordResetLinkListener failed: $error');
      }
    } finally {
      _isHandlingLink = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
