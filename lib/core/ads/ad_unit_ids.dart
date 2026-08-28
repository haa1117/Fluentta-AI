import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';

/// AdMob unit IDs live in the app only — never in Firestore.
/// One unit ID per ad format: native, banner, rewarded.
/// Firestore controls *where* ads show (placements), not unit IDs.
class AdUnitIds {
  AdUnitIds._();
 
  static const androidTestAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const iosTestAppId = 'ca-app-pub-3940256099942544~1458002511';

  // TODO: Replace with your real AdMob App IDs before release.
  static const androidProductionAppId =
      'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';
  static const iosProductionAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';

  // --- Test unit IDs (Google official) ---
  static const androidTestNative = 'ca-app-pub-3940256099942544/2247696110';
  static const iosTestNative = 'ca-app-pub-3940256099942544/3986624511';
  static const androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const androidTestRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const iosTestRewarded = 'ca-app-pub-3940256099942544/1712485313';
  static const androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const iosTestInterstitial = 'ca-app-pub-3940256099942544/4411468910';

  // TODO: Replace with your real AdMob unit IDs before release.
  static const androidProductionNative =
      'ca-app-pub-XXXXXXXXXXXXXXXX/NATIVE0000';
  static const iosProductionNative = 'ca-app-pub-XXXXXXXXXXXXXXXX/NATIVE0000';
  static const androidProductionBanner =
      'ca-app-pub-XXXXXXXXXXXXXXXX/BANNER0000';
  static const iosProductionBanner = 'ca-app-pub-XXXXXXXXXXXXXXXX/BANNER0000';
  static const androidProductionRewarded =
      'ca-app-pub-XXXXXXXXXXXXXXXX/REWARD0000';
  static const iosProductionRewarded = 'ca-app-pub-XXXXXXXXXXXXXXXX/REWARD0000';
  static const androidProductionInterstitial =
      'ca-app-pub-XXXXXXXXXXXXXXXX/INTER00000';
  static const iosProductionInterstitial =
      'ca-app-pub-XXXXXXXXXXXXXXXX/INTER00000';

  static bool get _productionConfigured =>
      !androidProductionAppId.contains('XXXXXXXX') &&
      !iosProductionAppId.contains('XXXXXXXX') &&
      !androidProductionNative.contains('XXXXXXXX') &&
      !iosProductionNative.contains('XXXXXXXX') &&
      !androidProductionBanner.contains('XXXXXXXX') &&
      !iosProductionBanner.contains('XXXXXXXX') &&
      !androidProductionRewarded.contains('XXXXXXXX') &&
      !iosProductionRewarded.contains('XXXXXXXX') &&
      !androidProductionInterstitial.contains('XXXXXXXX') &&
      !iosProductionInterstitial.contains('XXXXXXXX');

  static bool get useTestIds => kDebugMode || !_productionConfigured;

  static String get androidAppId =>
      useTestIds ? androidTestAppId : androidProductionAppId;

  static String get iosAppId => useTestIds ? iosTestAppId : iosProductionAppId;

  static String unitId(AdPlacement placement) {
    if (placement.isInterstitial) {
      return _interstitialUnitId;
    }
    if (placement.isRewarded) {
      return _rewardedUnitId;
    }
    if (placement.isNative) {
      return _nativeUnitId;
    }
    return _bannerUnitId;
  }

  static String get _nativeUnitId {
    if (useTestIds) {
      return Platform.isIOS ? iosTestNative : androidTestNative;
    }
    return Platform.isIOS ? iosProductionNative : androidProductionNative;
  }

  static String get _bannerUnitId {
    if (useTestIds) {
      return Platform.isIOS ? iosTestBanner : androidTestBanner;
    }
    return Platform.isIOS ? iosProductionBanner : androidProductionBanner;
  }

  static String get _rewardedUnitId {
    if (useTestIds) {
      return Platform.isIOS ? iosTestRewarded : androidTestRewarded;
    }
    return Platform.isIOS ? iosProductionRewarded : androidProductionRewarded;
  }

  static String get _interstitialUnitId {
    if (useTestIds) {
      return Platform.isIOS ? iosTestInterstitial : androidTestInterstitial;
    }
    return Platform.isIOS
        ? iosProductionInterstitial
        : androidProductionInterstitial;
  }
}
