import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Firebase Remote Config. Screens that read these keys can be added later;
/// fetch runs at launch so values are ready when those screens land.
class AppRemoteConfig {
  AppRemoteConfig._();

  static final AppRemoteConfig instance = AppRemoteConfig._();

  static const adsMasterEnabledKey = 'ads_master_enabled';

  bool _ready = false;
  bool get isReady => _ready;

  FirebaseRemoteConfig get _rc => FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      await _rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 8),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      await _rc.setDefaults(const {
        adsMasterEnabledKey: true,
      });
      await _rc.fetchAndActivate();
      _ready = true;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('AppRemoteConfig.initialize failed: $error');
      }
    }
  }

  bool get adsMasterEnabled {
    if (!_ready) return true;
    try {
      return _rc.getBool(adsMasterEnabledKey);
    } catch (_) {
      return true;
    }
  }

  bool boolFor(String key, {bool fallback = false}) {
    try {
      return _rc.getBool(key);
    } catch (_) {
      return fallback;
    }
  }

  String stringFor(String key, {String fallback = ''}) {
    try {
      final value = _rc.getString(key);
      return value.isEmpty ? fallback : value;
    } catch (_) {
      return fallback;
    }
  }
}
