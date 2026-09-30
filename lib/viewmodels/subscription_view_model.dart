import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/cefr/cefr_level_progress.dart';
import 'package:fluentta_ai/core/iap/iap_product_ids.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/utils/simple_uuid.dart';
import 'package:fluentta_ai/data/models/subscription_models.dart';
import 'package:fluentta_ai/data/services/iap_service.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
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

  String _conversionJourneyId = generateUuidV4();
  String _paywallFeatureTrigger = 'other';

  /// Correlates every analytics event fired during one paywall visit. This
  /// view model is a single app-scoped instance (see main.dart), not
  /// recreated per screen, so [startPaywallSession] regenerates the id each
  /// time the paywall is opened.
  String get conversionJourneyId => _conversionJourneyId;
  String get paywallFeatureTrigger => _paywallFeatureTrigger;

  void startPaywallSession({required String featureTrigger}) {
    _conversionJourneyId = generateUuidV4();
    _paywallFeatureTrigger = featureTrigger;
  }

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

  String primaryButtonText(AppLocalizations l10n) {
    if (isHeartsSelection) {
      return l10n.buyHeartsCount(selectedHeartCount);
    }
    return switch (_selection) {
      SubscriptionSelection.annual => l10n.startFreeTrialDays(7),
      SubscriptionSelection.monthly => l10n.startFreeTrialDays(3),
      _ => l10n.continueBtn,
    };
  }

  String primaryDisclaimer(AppLocalizations l10n) {
    if (isHeartsSelection) return l10n.heartsOneTimePurchase;
    return switch (_selection) {
      SubscriptionSelection.annual ||
      SubscriptionSelection.monthly =>
        l10n.cancelAnytimeNoCharge,
      _ => l10n.unlocksInstantly,
    };
  }

  String discountAnnualPrice(AppLocalizations l10n) {
    // The actual first-year discount is applied by the store's introductory
    // offer at checkout; here we just show the annual plan's list price.
    return _iapService.formattedPrice(IapProductIds.annual) ??
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
    final level = CefrLevel.fromSetupId(_localStorage.englishLevel);
    return CefrLevelProgress.levelNameLabel(l10n, level);
  }

  int get dailyMinutes => _localStorage.dailyGoalMinutes ?? 10;

  List<String> planFeatures(AppLocalizations l10n) {
    return [
      l10n.featureUnlimitedAiConversation,
      l10n.featureUnlimitedPronunciationPractice,
      l10n.featureUnlimitedGrammar,
      l10n.featureAllRoleplayScenarios,
      l10n.featureB2PlusContent,
      l10n.featureWeeklyProgressReport,
      l10n.featureUnlimitedStreakFreezes,
      l10n.featureStreakRepairPerMonth,
    ];
  }

  Future<PurchaseFlowResult> purchaseSelected() async {
    if (_isPurchasing) {
      return PurchaseFlowResult(
        success: false,
        message: l10nFor(_localStorage.selectedLanguage ?? 'en')
            .iapPurchaseInProgress,
      );
    }

    _isPurchasing = true;
    notifyListeners();

    final result = await _iapService.purchaseSelection(
      _selection,
      conversionJourneyId: _conversionJourneyId,
    );

    _isPurchasing = false;
    notifyListeners();
    return result;
  }

  Future<PurchaseFlowResult> purchaseDiscountAnnual() async {
    if (_isPurchasing) {
      return PurchaseFlowResult(
        success: false,
        message: l10nFor(_localStorage.selectedLanguage ?? 'en')
            .iapPurchaseInProgress,
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
    final result = await _iapService.restorePurchases(
      conversionJourneyId: _conversionJourneyId,
    );
    notifyListeners();
    return result;
  }
}
