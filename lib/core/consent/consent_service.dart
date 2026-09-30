import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Collects ad consent: Google UMP (GDPR / US state laws) first, then Apple's
/// App Tracking Transparency prompt on iOS. Ads must not be requested until
/// [gatherConsent] resolves to true.
class ConsentService extends ChangeNotifier {
  ConsentService._();

  static final ConsentService instance = ConsentService._();

  Future<bool>? _gathering;
  bool _canRequestAds = false;
  bool _privacyOptionsRequired = false;

  bool get canRequestAds => _canRequestAds;

  /// True when the user's region requires a "Privacy settings" entry point.
  bool get privacyOptionsRequired => _privacyOptionsRequired;

  bool get _isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Runs the consent flow once per app session and returns whether ads may
  /// be requested.
  Future<bool> gatherConsent() => _gathering ??= _gather();

  Future<bool> _gather() async {
    if (!_isMobile) {
      _canRequestAds = true;
      return true;
    }

    // The UMP form and the ATT alert both need a visible screen.
    await WidgetsBinding.instance.endOfFrame;

    await _runUmp();
    await _requestTrackingAuthorization();
    await _refreshState();
    return _canRequestAds;
  }

  Future<void> _runUmp() async {
    final done = Completer<void>();

    void finish([FormError? error]) {
      if (error != null && kDebugMode) {
        debugPrint('UMP: ${error.errorCode} ${error.message}');
      }
      if (!done.isCompleted) done.complete();
    }

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () => ConsentForm.loadAndShowConsentFormIfRequired(finish),
        finish,
      );
      await done.future;
    } catch (error) {
      if (kDebugMode) debugPrint('UMP consent flow failed: $error');
    }
  }

  Future<void> _requestTrackingAuthorization() async {
    if (kIsWeb || !Platform.isIOS) return;
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status != TrackingStatus.notDetermined) return;
      // iOS only shows the alert once the app is fully active.
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    } catch (error) {
      if (kDebugMode) debugPrint('ATT request failed: $error');
    }
  }

  Future<void> _refreshState() async {
    try {
      _canRequestAds = await ConsentInformation.instance.canRequestAds();
      final status =
          await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
      _privacyOptionsRequired =
          status == PrivacyOptionsRequirementStatus.required;
    } catch (error) {
      if (kDebugMode) debugPrint('UMP state refresh failed: $error');
    }
    notifyListeners();
  }

  /// Opens the UMP privacy options form (Profile → Privacy Settings).
  Future<void> showPrivacyOptions() async {
    final done = Completer<void>();
    try {
      await ConsentForm.showPrivacyOptionsForm((error) {
        if (!done.isCompleted) done.complete();
      });
      await done.future;
    } catch (error) {
      if (kDebugMode) debugPrint('Privacy options form failed: $error');
    }
    await _refreshState();
  }
}
