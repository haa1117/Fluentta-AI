import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';

/// AdMob unit IDs live in the app only — never in Firestore.
/// Uses Google test IDs in debug and until production IDs are configured.
class AdUnitIds {
  AdUnitIds._();

  static const androidTestAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const iosTestAppId = 'ca-app-pub-3940256099942544~1458002511';

  // TODO: Replace with your real AdMob App IDs before release.
  static const androidProductionAppId =
      'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';
  static const iosProductionAppId = 'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';

  static bool get _productionConfigured =>
      !androidProductionAppId.contains('XXXXXXXX') &&
      !iosProductionAppId.contains('XXXXXXXX') &&
      !_productionAndroidUnits.values.any((id) => id.contains('XXXXXXXX')) &&
      !_productionIosUnits.values.any((id) => id.contains('XXXXXXXX'));

  static bool get useTestIds => kDebugMode || !_productionConfigured;

  static String get androidAppId =>
      useTestIds ? androidTestAppId : androidProductionAppId;

  static String get iosAppId => useTestIds ? iosTestAppId : iosProductionAppId;

  static String unitId(AdPlacement placement) {
    if (useTestIds) {
      return Platform.isIOS
          ? _testIosUnits[placement]!
          : _testAndroidUnits[placement]!;
    }
    return Platform.isIOS
        ? _productionIosUnits[placement]!
        : _productionAndroidUnits[placement]!;
  }

  static const _testAndroidUnits = {
    AdPlacement.onboardingNative: 'ca-app-pub-3940256099942544/2247696110',
    AdPlacement.homeBanner: 'ca-app-pub-3940256099942544/6300978111',
    AdPlacement.learnBanner: 'ca-app-pub-3940256099942544/6300978111',
    AdPlacement.setupBanner: 'ca-app-pub-3940256099942544/6300978111',
    AdPlacement.roleplayBanner: 'ca-app-pub-3940256099942544/6300978111',
    AdPlacement.lessonNative: 'ca-app-pub-3940256099942544/2247696110',
    AdPlacement.rewardedXpBoost: 'ca-app-pub-3940256099942544/5224354917',
  };

  static const _testIosUnits = {
    AdPlacement.onboardingNative: 'ca-app-pub-3940256099942544/3986624511',
    AdPlacement.homeBanner: 'ca-app-pub-3940256099942544/2934735716',
    AdPlacement.learnBanner: 'ca-app-pub-3940256099942544/2934735716',
    AdPlacement.setupBanner: 'ca-app-pub-3940256099942544/2934735716',
    AdPlacement.roleplayBanner: 'ca-app-pub-3940256099942544/2934735716',
    AdPlacement.lessonNative: 'ca-app-pub-3940256099942544/3986624511',
    AdPlacement.rewardedXpBoost: 'ca-app-pub-3940256099942544/1712485313',
  };

  // TODO: Replace with your real AdMob unit IDs before release.
  static const _productionAndroidUnits = {
    AdPlacement.onboardingNative: 'ca-app-pub-XXXXXXXXXXXXXXXX/AAAAAAAAAA',
    AdPlacement.homeBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB',
    AdPlacement.learnBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/CCCCCCCCCC',
    AdPlacement.setupBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/DDDDDDDDDD',
    AdPlacement.roleplayBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/EEEEEEEEEE',
    AdPlacement.lessonNative: 'ca-app-pub-XXXXXXXXXXXXXXXX/FFFFFFFFFF',
    AdPlacement.rewardedXpBoost: 'ca-app-pub-XXXXXXXXXXXXXXXX/GGGGGGGGGG',
  };

  static const _productionIosUnits = {
    AdPlacement.onboardingNative: 'ca-app-pub-XXXXXXXXXXXXXXXX/HHHHHHHHHH',
    AdPlacement.homeBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/IIIIIIIIII',
    AdPlacement.learnBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/JJJJJJJJJJ',
    AdPlacement.setupBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/KKKKKKKKKK',
    AdPlacement.roleplayBanner: 'ca-app-pub-XXXXXXXXXXXXXXXX/LLLLLLLLLL',
    AdPlacement.lessonNative: 'ca-app-pub-XXXXXXXXXXXXXXXX/MMMMMMMMMM',
    AdPlacement.rewardedXpBoost: 'ca-app-pub-XXXXXXXXXXXXXXXX/NNNNNNNNNN',
  };
}
