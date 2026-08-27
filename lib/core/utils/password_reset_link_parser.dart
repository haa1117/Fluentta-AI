import 'package:fluentta_ai/core/constants/auth_deep_link_config.dart';

class PasswordResetLinkData {
  const PasswordResetLinkData({
    required this.oobCode,
    this.email,
  });

  final String oobCode;
  final String? email;
}

class PasswordResetLinkParser {
  PasswordResetLinkParser._();

  static PasswordResetLinkData? parse(Uri uri) {
    if (uri.scheme == AuthDeepLinkConfig.customScheme) {
      final fromCustomScheme = _parseQuery(uri.queryParameters);
      if (fromCustomScheme != null) return fromCustomScheme;
    }

    final candidates = <Uri>[uri];

    final nestedLink = uri.queryParameters['link'];
    if (nestedLink != null && nestedLink.isNotEmpty) {
      candidates.add(Uri.tryParse(Uri.decodeComponent(nestedLink)) ?? uri);
    }

    final deepLinkId = uri.queryParameters['deep_link_id'];
    if (deepLinkId != null && deepLinkId.isNotEmpty) {
      candidates.add(Uri.tryParse(Uri.decodeComponent(deepLinkId)) ?? uri);
    }

    for (final candidate in candidates) {
      final fromQuery = _parseQuery(candidate.queryParameters);
      if (fromQuery != null) return fromQuery;

      if (candidate.fragment.isNotEmpty) {
        final fromFragment = _parseQuery(Uri.splitQueryString(candidate.fragment));
        if (fromFragment != null) return fromFragment;
      }
    }

    return null;
  }

  static PasswordResetLinkData? _parseQuery(Map<String, String> params) {
    final normalized = <String, String>{};
    for (final entry in params.entries) {
      normalized[entry.key.toLowerCase()] = entry.value;
    }

    final oobCode = normalized['oobcode'];
    if (oobCode == null || oobCode.isEmpty) {
      return null;
    }

    final mode = normalized['mode'];
    if (mode != null && mode.toLowerCase() != 'resetpassword') {
      return null;
    }

    return PasswordResetLinkData(
      oobCode: oobCode,
      email: normalized['email'] ?? normalized['continueurl'],
    );
  }
}
