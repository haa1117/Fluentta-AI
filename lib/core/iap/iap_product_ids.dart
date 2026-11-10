import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/data/models/subscription_models.dart';

/// Store product IDs for Fluenta.
///
/// Play is unchanged: one subscription product [playSubscriptionProduct] with
/// base plans [weekly], [monthly], [annual], plus consumables [hearts20],
/// [hearts60], and [hearts150].
///
/// App Store Connect (subscription group `fluenta.premium` and in-app
/// purchases). Subscriptions and lifetime use the same SKUs as Play. The 20
/// and 60 heart packs do not: App Store created them as [iosHearts20] and
/// [iosHearts60].
///
/// - [weekly] fluenta.premium.weekly
/// - [monthly] fluenta.premium.monthly
/// - [annual] fluenta.premium.annual
/// - [lifetime] fluenta.premium.lifetime
/// - [iosHearts20] fluenta.heart.20
/// - [iosHearts60] fluenta.heart.60
/// - [hearts150] fluenta.hearts.150
class IapProductIds {
  IapProductIds._();

  /// Google Play subscription product (base plans live under this ID).
  static const String playSubscriptionProduct = 'fluenta.premium';

  static const String weekly = 'fluenta.premium.weekly';
  static const String monthly = 'fluenta.premium.monthly';
  static const String annual = 'fluenta.premium.annual';
  static const String lifetime = 'fluenta.premium.lifetime';

  static const String hearts20 = 'fluenta.hearts.20';
  static const String hearts60 = 'fluenta.hearts.60';
  static const String hearts150 = 'fluenta.hearts.150';

  /// App Store Connect consumables. 20 and 60 use singular `heart`.
  static const String iosHearts20 = 'fluenta.heart.20';
  static const String iosHearts60 = 'fluenta.heart.60';

  static const Set<String> subscriptionIds = {
    weekly,
    monthly,
    annual,
  };

  static const Set<String> nonConsumableIds = {lifetime};

  static const Set<String> consumableIds = {
    hearts20,
    hearts60,
    hearts150,
  };

  /// Exact App Store Connect catalog. Does not include [playSubscriptionProduct].
  static const Set<String> iosProductIds = {
    weekly,
    monthly,
    annual,
    lifetime,
    iosHearts20,
    iosHearts60,
    hearts150,
  };

  static bool get _isIos =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Heart pack id for the store the app is running on.
  static String get storeHearts20 => _isIos ? iosHearts20 : hearts20;

  static String get storeHearts60 => _isIos ? iosHearts60 : hearts60;

  static String get storeHearts150 => hearts150;

  /// Play catalog. Left as its own set so Android queries stay the same.
  static Set<String> get allProductIds => {
        playSubscriptionProduct,
        ...subscriptionIds,
        ...nonConsumableIds,
        ...consumableIds,
      };

  /// IDs passed to the current store. Android receives [allProductIds].
  static Set<String> get idsForCurrentStore =>
      _isIos ? iosProductIds : allProductIds;

  /// Maps a Play Console base-plan ID onto our weekly/monthly/annual SKUs.
  ///
  /// Console IDs are `fluentapremiumweekly`, `fluentapremiummonthly`, and
  /// `fluentapremiumannual` under product [playSubscriptionProduct].
  static String? idForPlayBasePlan(String basePlanId) {
    final id = basePlanId.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (id.endsWith('weekly')) return weekly;
    if (id.endsWith('monthly')) return monthly;
    if (id.endsWith('annual') || id.endsWith('yearly')) return annual;
    return null;
  }

  static String? idForSelection(SubscriptionSelection selection) {
    return switch (selection) {
      SubscriptionSelection.annual => annual,
      SubscriptionSelection.weekly => weekly,
      SubscriptionSelection.monthly => monthly,
      SubscriptionSelection.lifetime => lifetime,
      SubscriptionSelection.heartsSmall => storeHearts20,
      SubscriptionSelection.heartsMedium => storeHearts60,
      SubscriptionSelection.heartsLarge => storeHearts150,
    };
  }

  static bool isConsumable(String productId) => isHeartsProduct(productId);

  static bool isPremiumProduct(String productId) {
    return subscriptionIds.contains(productId) ||
        productId == lifetime ||
        productId == playSubscriptionProduct;
  }

  static bool isHeartsProduct(String productId) {
    return consumableIds.contains(productId) ||
        productId == iosHearts20 ||
        productId == iosHearts60;
  }

  static int heartsForProductId(String productId) {
    return switch (productId) {
      hearts20 || iosHearts20 => 20,
      hearts60 || iosHearts60 => 60,
      hearts150 => 150,
      _ => 0,
    };
  }
}
