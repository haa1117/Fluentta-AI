import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalUrls {
  LegalUrls._();

  static const privacyPolicy =
      'https://fwglobal.co/privacy/co.fwglobal.fluenta';
  static const termsOfUse = 'https://fwglobal.co/terms';
  static const supportEmail = 'info@fwglobal.co';

  static Future<void> openPrivacyPolicy(BuildContext context) {
    return _open(context, privacyPolicy, context.l10n.privacyPolicy);
  }

  static Future<void> openTermsOfUse(BuildContext context) {
    return _open(context, termsOfUse, context.l10n.termsOfUse);
  }

  static Future<void> openContactSupport(BuildContext context) {
    return _open(
      context,
      'mailto:$supportEmail',
      context.l10n.contactSupport,
    );
  }

  static Future<void> _open(
    BuildContext context,
    String url,
    String fallbackLabel,
  ) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: url.startsWith('mailto:')
            ? LaunchMode.platformDefault
            : LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        SnackbarHelper.showError(context, fallbackLabel);
      }
    } catch (_) {
      if (context.mounted) {
        SnackbarHelper.showError(context, fallbackLabel);
      }
    }
  }
}
