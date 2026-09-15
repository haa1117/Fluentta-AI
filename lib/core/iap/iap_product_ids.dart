import 'package:fluentta_ai/data/models/subscription_models.dart';

/// Store product IDs for Fluenta. Must match exactly what is registered in
/// App Store Connect and Google Play Console (kept identical across platforms).
///
/// Auto-renewable subscriptions (one subscription group, `fluenta_premium`):
/// - [weekly]   fluenta.premium.weekly
/// - [monthly]  fluenta.premium.monthly
/// - [annual]   fluenta.premium.annual — hero SKU, 7-day trial + optional
///              "50% off first year" introductory offer (an offer on THIS
///              product, not a separate SKU)
///
/// Non-consumable:
/// - [lifetime] fluenta.premium.lifetime
///
/// Consumables (hearts):
/// - [hearts20] fluenta.hearts.20
/// - [hearts60] fluenta.hearts.60
/// - [hearts150] fluenta.hearts.150
class IapProductIds {
  IapProductIds._();

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
        ...subscriptionIds,
        ...nonConsumableIds,
        ...consumableIds,
      };

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
        productId == lifetime;
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
