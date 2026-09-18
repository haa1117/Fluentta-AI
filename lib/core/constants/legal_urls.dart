import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalUrls {
  LegalUrls._();

  static const privacyPolicy =
      'https://fwglobal.co/privacy/co.fwglobal.fluenta';
  static const termsOfUse = 'https://fwglobal.co/terms';

  static Future<void> openPrivacyPolicy(BuildContext context) {
    return _open(context, privacyPolicy, context.l10n.privacyPolicy);
  }

  static Future<void> openTermsOfUse(BuildContext context) {
    return _open(context, termsOfUse, context.l10n.termsOfUse);
  }

  static Future<void> _open(
    BuildContext context,
    String url,
    String fallbackLabel,
  ) async {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      SnackbarHelper.showError(context, fallbackLabel);
    }
  }
}
