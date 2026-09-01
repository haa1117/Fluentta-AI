import 'package:fluentta_ai/core/iap/iap_product_ids.dart';

enum SubscriptionSelection {
  annual,
  weekly,
  monthly,
  lifetime,
  heartsSmall,
  heartsMedium,
  heartsLarge,
}

class PurchaseFlowResult {
  const PurchaseFlowResult({
    required this.success,
    this.message,
    this.heartsAdded,
    this.isPremium = false,
  });

  final bool success;
  final String? message;
  final int? heartsAdded;
  final bool isPremium;
}

class HeartPackOption {
  const HeartPackOption({
    required this.selection,
    required this.hearts,
    required this.price,
    required this.labelKey,
  });

  final SubscriptionSelection selection;
  final int hearts;
  final String price;
  final String labelKey;
}

class SubscriptionPlanOption {
  const SubscriptionPlanOption({
    required this.selection,
    required this.price,
    this.subtitle,
    this.perMonth,
    this.badge,
    this.extraLabel,
  });

  final SubscriptionSelection selection;
  final String price;
  final String? subtitle;
  final String? perMonth;
  final String? badge;
  final String? extraLabel;

  bool get isAnnual => selection == SubscriptionSelection.annual;
  bool get isCompact => !isAnnual;
}

class SubscriptionContent {
  SubscriptionContent._();

  static List<HeartPackOption> heartPacks({Map<String, String>? livePrices}) {
    return [
      HeartPackOption(
        selection: SubscriptionSelection.heartsSmall,
        hearts: 20,
        price: livePrices?[IapProductIds.hearts20] ?? r'$1.99',
        labelKey: 'small',
      ),
      HeartPackOption(
        selection: SubscriptionSelection.heartsMedium,
        hearts: 60,
        price: livePrices?[IapProductIds.hearts60] ?? r'$4.99',
        labelKey: 'medium',
      ),
      HeartPackOption(
        selection: SubscriptionSelection.heartsLarge,
        hearts: 150,
        price: livePrices?[IapProductIds.hearts150] ?? r'$9.99',
        labelKey: 'large',
      ),
    ];
  }

  static int heartsForSelection(SubscriptionSelection selection) {
    for (final pack in heartPacks()) {
      if (pack.selection == selection) return pack.hearts;
    }
    return 0;
  }

  static bool isHeartsSelection(SubscriptionSelection selection) {
    return selection == SubscriptionSelection.heartsSmall ||
        selection == SubscriptionSelection.heartsMedium ||
        selection == SubscriptionSelection.heartsLarge;
  }
}
