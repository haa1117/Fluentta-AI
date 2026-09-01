import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/iap/iap_product_ids.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/subscription_models.dart';
import 'package:fluentta_ai/data/services/iap_service.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';

class SubscriptionViewModel extends ChangeNotifier {
  SubscriptionViewModel(
    this._localStorage,
    this._homeViewModel,
    this._iapService,
  ) {
    _initStore();
  }

  final LocalStorage _localStorage;
  final HomeViewModel _homeViewModel;
  final IapService _iapService;

  SubscriptionSelection _selection = SubscriptionSelection.annual;
  bool _isPurchasing = false;

  SubscriptionSelection get selection => _selection;
  int get currentLives => _homeViewModel.lives;
  bool get isPremium => _localStorage.isPremium;
  bool get isPurchasing => _isPurchasing;
  bool get isStoreAvailable => _iapService.isStoreAvailable;

  bool get isHeartsSelection =>
      SubscriptionContent.isHeartsSelection(_selection);

  int get selectedHeartCount =>
      SubscriptionContent.heartsForSelection(_selection);

  List<HeartPackOption> get heartPacks {
    final livePrices = <String, String>{};
    for (final id in [
      IapProductIds.hearts20,
      IapProductIds.hearts60,
      IapProductIds.hearts150,
    ]) {
      final price = _iapService.formattedPrice(id);
      if (price != null) {
        livePrices[id] = price;
      }
    }
    return SubscriptionContent.heartPacks(livePrices: livePrices);
  }

  Future<void> _initStore() async {
    await _iapService.initialize();
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await _iapService.loadProducts();
    notifyListeners();
  }

  void select(SubscriptionSelection value) {
    if (_selection == value) return;
    _selection = value;
    notifyListeners();
  }

  String planPrice(SubscriptionSelection selection, AppLocalizations l10n) {
    final productId = IapProductIds.idForSelection(selection);
    final livePrice =
        productId == null ? null : _iapService.formattedPrice(productId);
    if (livePrice != null) {
      return switch (selection) {
        SubscriptionSelection.annual => '$livePrice/yr',
        _ => livePrice,
      };
    }
    return switch (selection) {
      SubscriptionSelection.annual => l10n.annualPrice,
      SubscriptionSelection.weekly => l10n.weeklyPrice,
      SubscriptionSelection.monthly => l10n.monthlyPrice,
      SubscriptionSelection.lifetime => l10n.lifetimePrice,
      _ => '',
    };
  }

  String planPricePerMonth(AppLocalizations l10n) {
    final liveMonthly =
        _iapService.formattedMonthlyFromAnnual(IapProductIds.annual);
    if (liveMonthly != null) {
      return "That's $liveMonthly";
    }
    return l10n.annualPricePerMonth;
  }

  String discountAnnualPrice(AppLocalizations l10n) {
    return _iapService.formattedPrice(IapProductIds.annualDiscount) ??
        l10n.annualProPrice;
  }

  String discountAnnualStrikethrough(AppLocalizations l10n) {
    final regular = _iapService.formattedPrice(IapProductIds.annual);
    if (regular != null) {
      return '$regular/yr';
    }
    return l10n.annualProPriceStrikethrough;
  }

  String goalLabel(AppLocalizations l10n) {
    return switch (_localStorage.englishGoal) {
      'travel' => l10n.goalTravel,
      'work' => l10n.goalWork,
      'exam' => l10n.goalExam,
      'everyday' => l10n.goalEveryday,
      _ => l10n.goalWork,
    };
  }

  String levelLabel(AppLocalizations l10n) {
    return switch (_localStorage.englishLevel) {
      'elementary' => l10n.levelElementary,
      'intermediate' => l10n.levelIntermediate,
      'advanced' => l10n.levelAdvanced,
      _ => l10n.levelBeginner,
    };
  }

  int get dailyMinutes => _localStorage.dailyGoalMinutes ?? 10;

  List<String> planFeatures(AppLocalizations l10n) {
    return [
      'Unlimited AI conversation',
      'Unlimited pronunciation practice',
      'Unlimited grammar corrections',
      'All roleplay scenarios',
      'B2+ lesson content',
      l10n.featureOfflineMode,
      'Weekly progress report',
      'Unlimited streak freezes',
      '1 streak repair per month',
    ];
  }

  Future<PurchaseFlowResult> purchaseSelected() async {
    if (_isPurchasing) {
      return const PurchaseFlowResult(
        success: false,
        message: 'Purchase already in progress.',
      );
    }

    _isPurchasing = true;
    notifyListeners();

    final result = await _iapService.purchaseSelection(_selection);

    _isPurchasing = false;
    notifyListeners();
    return result;
  }

  Future<PurchaseFlowResult> purchaseDiscountAnnual() async {
    if (_isPurchasing) {
      return const PurchaseFlowResult(
        success: false,
        message: 'Purchase already in progress.',
      );
    }

    _isPurchasing = true;
    notifyListeners();

    final result = await _iapService.purchaseDiscountAnnual();

    _isPurchasing = false;
    notifyListeners();
    return result;
  }

  Future<PurchaseFlowResult> restorePurchases() async {
    final result = await _iapService.restorePurchases();
    notifyListeners();
    return result;
  }
}
