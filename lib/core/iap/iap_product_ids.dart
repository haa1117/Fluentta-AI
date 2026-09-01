import 'package:fluentta_ai/data/models/subscription_models.dart';

/// Google Play Console product IDs for Fluentta AI.
///
/// Subscriptions (Monetize → Subscriptions):
/// - [annual]            Base plan + optional 3-day free trial offer
/// - [annualDiscount]    Promotional annual plan (50% off first year)
/// - [weekly]            Weekly base plan
/// - [monthly]           Monthly base plan
///
/// In-app products (Monetize → In-app products):
/// - [lifetime]          Managed product, non-consumable
/// - [hearts20]          Consumable
/// - [hearts60]          Consumable
/// - [hearts150]         Consumable
class IapProductIds {
  IapProductIds._();

  static const String annual = 'fluentta_sub_annual';
  static const String annualDiscount = 'fluentta_sub_annual_discount';
  static const String weekly = 'fluentta_sub_weekly';
  static const String monthly = 'fluentta_sub_monthly';
  static const String lifetime = 'fluentta_lifetime';

  static const String hearts20 = 'fluentta_hearts_20';
  static const String hearts60 = 'fluentta_hearts_60';
  static const String hearts150 = 'fluentta_hearts_150';

  static const Set<String> subscriptionIds = {
    annual,
    annualDiscount,
    weekly,
    monthly,
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
