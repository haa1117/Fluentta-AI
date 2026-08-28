import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';

/// AdMob App + unit IDs (app-only — never in Firestore).
/// Debug builds use Google test IDs; release/profile use Fluenta production IDs.
class AdUnitIds {
  AdUnitIds._();

  // --- Fluenta AI English — production App IDs ---
  static const androidProductionAppId =
      'ca-app-pub-6089058405886012~9881099688';
  static const iosProductionAppId = 'ca-app-pub-6089058405886012~5136109276';

  // --- Google test App IDs (debug only) ---
  static const androidTestAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const iosTestAppId = 'ca-app-pub-3940256099942544~1458002511';

  // --- Production unit IDs (Fluenta AI English) ---
  static const androidProductionAppOpen =
      'ca-app-pub-6089058405886012/8709392313';
  static const iosProductionAppOpen =
      'ca-app-pub-6089058405886012/4747000531';
  static const androidProductionBanner =
      'ca-app-pub-6089058405886012/2326043292';
  static const iosProductionBanner = 'ca-app-pub-6089058405886012/6508523399';
  static const androidProductionInterstitial =
      'ca-app-pub-6089058405886012/3568746279';
  static const iosProductionInterstitial =
      'ca-app-pub-6089058405886012/2503980579';
  static const androidProductionNative =
      'ca-app-pub-6089058405886012/5292891480';
  static const iosProductionNative = 'ca-app-pub-6089058405886012/5838816859';
  static const androidProductionRewarded =
      'ca-app-pub-6089058405886012/8521690050';
  static const iosProductionRewarded =
      'ca-app-pub-6089058405886012/1190898902';
  static const androidProductionRewardedInterstitial =
      'ca-app-pub-6089058405886012/3447553271';
  static const iosProductionRewardedInterstitial =
      'ca-app-pub-6089058405886012/4529604615';

  // --- Google official test unit IDs (debug only) ---
  static const androidTestNative = 'ca-app-pub-3940256099942544/2247696110';
  static const iosTestNative = 'ca-app-pub-3940256099942544/3986624511';
  static const androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const androidTestInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const iosTestInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const androidTestRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const iosTestRewarded = 'ca-app-pub-3940256099942544/1712485313';

  /// Debug → test ad units. Release/profile → Fluenta production units.
  static bool get useTestIds => kDebugMode;

  static String get androidAppId =>
      useTestIds ? androidTestAppId : androidProductionAppId;

  static String get iosAppId =>
      useTestIds ? iosTestAppId : iosProductionAppId;

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
