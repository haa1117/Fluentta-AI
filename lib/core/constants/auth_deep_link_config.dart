class AuthDeepLinkConfig {
  AuthDeepLinkConfig._();

  static const String projectId = 'fluenttaai';
  static const String androidPackageName = 'com.futurewatch.fluenta';
  static const String iOSBundleId = 'com.futurewatch.fluenta';
  static const String authHost = '$projectId.firebaseapp.com';
  static const String webAppHost = '$projectId.web.app';
  static const String continueUrl = 'https://$webAppHost/reset-password';
  static const String customScheme = androidPackageName;
}
