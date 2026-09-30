import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';

class OnlineGate {
  OnlineGate._();

  static bool get isOnline => NetworkStatus.lastKnownOnline;

  static void throwIfOffline() {
    if (isOnline) return;
    throw FirebaseAuthException(
      code: 'network-request-failed',
      message: 'offline',
    );
  }

  static bool guard(BuildContext context) {
    if (isOnline) return true;
    SnackbarHelper.showError(context, context.l10n.featureNeedsInternet);
    return false;
  }
}
