import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around [FirebaseAnalytics] (GA4). Centralizes event logging
/// so call sites use typed constants (see [AnalyticsEvents]/[AnalyticsParams])
/// instead of raw strings, and so parameter sanitization happens in one place.
class AnalyticsService {
  AnalyticsService._();

  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  /// Fires the canonical `screen_view` event. Call once when a registry
  /// screen actually becomes active (see catalogue rule #2) — not for
  /// loading overlays, expanded sections, or native SDK sheets.
  Future<void> logScreenView(String screenName) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        parameters: {'firebase_screen': screenName},
      );
    } catch (error) {
      _logError('logScreenView($screenName)', error);
    }
  }

  /// Fires a custom event with the given [params]. Values are sanitized:
  /// null entries are dropped, bools become 'true'/'false' (the GA4 SDK only
  /// accepts String/num), everything else is passed through.
  Future<void> log(String name, [Map<String, Object?>? params]) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: _sanitize(params),
      );
    } catch (error) {
      _logError('log($name)', error);
    }
  }

  Future<void> setUserId(String? id) async {
    try {
      await _analytics.setUserId(id: id);
    } catch (error) {
      _logError('setUserId', error);
    }
  }

  Future<void> setUserProperty(String name, String? value) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (error) {
      _logError('setUserProperty($name)', error);
    }
  }

  Map<String, Object>? _sanitize(Map<String, Object?>? params) {
    if (params == null) return null;
    final result = <String, Object>{};
    for (final entry in params.entries) {
      final value = entry.value;
      if (value == null) continue;
      result[entry.key] = value is bool ? value.toString() : value;
    }
    return result.isEmpty ? null : result;
  }

  void _logError(String what, Object error) {
    // Analytics must never crash or block a user flow.
    if (kDebugMode) {
      debugPrint('AnalyticsService.$what failed: $error');
    }
  }
}
