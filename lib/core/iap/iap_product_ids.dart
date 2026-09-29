import 'package:fluentta_ai/data/models/subscription_models.dart';

/// Store product IDs for Fluenta. Must match App Store Connect and Play Console.
///
/// Play: one subscription product [playSubscriptionProduct] with base plans
/// [weekly], [monthly], [annual]. iOS: those three are auto-renewable SKUs
/// in subscription group `fluenta.premium`.
///
/// Non-consumable:
/// - [lifetime] fluenta.premium.lifetime — billed immediately
///
/// Consumables (hearts, billed immediately):
/// - [hearts20] fluenta.hearts.20
/// - [hearts60] fluenta.hearts.60
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

  static Set<String> get allProductIds => {
        playSubscriptionProduct,
        ...subscriptionIds,
        ...nonConsumableIds,
        ...consumableIds,
      };

  /// Maps a Play Console base-plan ID onto our weekly/monthly/annual SKUs.
  static String? idForPlayBasePlan(String basePlanId) {
    final id = basePlanId.toLowerCase();
    if (id == weekly || id == 'weekly' || id.endsWith('.weekly')) {
      return weekly;
    }
    if (id == monthly || id == 'monthly' || id.endsWith('.monthly')) {
      return monthly;
    }
    if (id == annual ||
        id == 'annual' ||
        id == 'yearly' ||
        id.endsWith('.annual')) {
      return annual;
    }
    return null;
  }

  static String? idForSelection(SubscriptionSelection selection) {
    return switch (selection) {
      SubscriptionSelection.annual => annual,
      SubscriptionSelection.weekly => weekly,
      SubscriptionSelection.monthly => monthly,
      SubscriptionSelection.lifetime => lifetime,
      SubscriptionSelection.heartsSmall => hearts20,
      SubscriptionSelection.heartsMedium => hearts60,
      SubscriptionSelection.heartsLarge => hearts150,
    };
  }

  static bool isConsumable(String productId) => consumableIds.contains(productId);

  static bool isPremiumProduct(String productId) {
    return subscriptionIds.contains(productId) ||
        productId == lifetime ||
        productId == playSubscriptionProduct;
  }

  static bool isHeartsProduct(String productId) =>
      consumableIds.contains(productId);

  static int heartsForProductId(String productId) {
    return switch (productId) {
      hearts20 => 20,
      hearts60 => 60,
      hearts150 => 150,
      _ => 0,
    };
  }
}
