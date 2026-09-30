import 'dart:async';

import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/iap/iap_product_ids.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/subscription_models.dart';
import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class IapService {
  IapService(this._localStorage, this._homeViewModel);

  final LocalStorage _localStorage;
  final HomeViewModel _homeViewModel;
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  final Map<String, ProductDetails> _products = {};
  /// Free-trial offer tokens keyed by our weekly/monthly/annual SKU.
  final Map<String, String> _trialOfferTokens = {};

  AppLocalizations get _l10n =>
      l10nFor(_localStorage.selectedLanguage ?? 'en');

  bool _isAvailable = false;
  bool _isLoadingProducts = false;

  bool get isStoreAvailable => _isAvailable;
  bool get isLoadingProducts => _isLoadingProducts;

  Completer<PurchaseFlowResult>? _activePurchaseCompleter;
  // Threaded from the paywall session (see SubscriptionViewModel) through the
  // async purchase-stream callbacks, which don't otherwise have access to
  // the originating call's arguments.
  String? _activeConversionJourneyId;
  int _heartBalanceBeforeActivePurchase = 0;

  String _planTypeForProductId(String productId) {
    if (productId == IapProductIds.annual) return 'annual';
    if (productId == IapProductIds.weekly) return 'weekly';
    if (productId == IapProductIds.monthly) return 'monthly';
    if (productId == IapProductIds.lifetime) return 'lifetime';
    return 'unknown';
  }

  void _logPurchaseLifecycleEvent(
    String productId, {
    required String heartsEvent,
    required String subscriptionEvent,
    Map<String, Object?> extraParams = const {},
  }) {
    final isHearts = IapProductIds.isHeartsProduct(productId);
    AnalyticsService.instance.log(isHearts ? heartsEvent : subscriptionEvent, {
      AnalyticsParams.conversionJourneyId: _activeConversionJourneyId,
      AnalyticsParams.productId: productId,
      if (isHearts)
        AnalyticsParams.heartPackSize:
            IapProductIds.heartsForProductId(productId)
      else
        AnalyticsParams.planType: _planTypeForProductId(productId),
      ...extraParams,
    });
  }

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    _purchaseSubscription ??= _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) {
        _completeActivePurchase(
          PurchaseFlowResult(
            success: false,
            message: _l10n.iapPurchaseFailed,
          ),
        );
      },
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    _isLoadingProducts = true;
    final response = await _iap.queryProductDetails(IapProductIds.allProductIds);
    _products.clear();
    _trialOfferTokens.clear();
    for (final product in response.productDetails) {
      _indexProduct(product);
    }
    _isLoadingProducts = false;

    if (response.notFoundIDs.isNotEmpty) {
      // Products not configured in Play Console yet — fallbacks still work.
    }
  }

  /// Play returns one [ProductDetails] per subscription offer, all sharing
  /// the product id `fluenta.premium`. Index the base plan under the SKU the
  /// paywall asks for, and keep a free-trial token when that offer exists.
  void _indexProduct(ProductDetails product) {
    if (product is GooglePlayProductDetails) {
      final offer = _subscriptionOffer(product);
      if (offer != null) {
        final sku = IapProductIds.idForPlayBasePlan(offer.basePlanId);
        if (sku != null) {
          final offerId = offer.offerId?.toLowerCase();
          if (offerId != null && offerId.contains('trial')) {
            _trialOfferTokens[sku] = offer.offerToken;
            _products.putIfAbsent(sku, () => product);
          } else if (offer.offerId == null) {
            _products[sku] = product;
          }
          return;
        }
      }
    }
    _products[product.id] = product;
  }

  /// Play's offer class is not exported, so only the fields we use are returned.
  ({String basePlanId, String? offerId, String offerToken})? _subscriptionOffer(
    GooglePlayProductDetails product,
  ) {
    final index = product.subscriptionIndex;
    final offers = product.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) return null;
    final offer = offers[index];
    return (
      basePlanId: offer.basePlanId,
      offerId: offer.offerId,
      offerToken: offer.offerIdToken,
    );
  }

  ProductDetails? productDetails(String productId) => _products[productId];

  String? formattedPrice(String productId) => _products[productId]?.price;

  double? rawPrice(String productId) => _products[productId]?.rawPrice;

  String? formattedMonthlyFromAnnual(String productId) {
    final product = _products[productId];
    if (product == null) return null;
    final monthly = product.rawPrice / 12;
    final currency = product.currencyCode;
    if (currency.isEmpty) return null;
    return '${_currencySymbol(currency)}${monthly.toStringAsFixed(2)}/mo';
  }

  Future<PurchaseFlowResult> purchaseSelection(
    SubscriptionSelection selection, {
    String? conversionJourneyId,
  }) async {
    final productId = IapProductIds.idForSelection(selection);
    if (productId == null) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.iapInvalidProduct,
      );
    }
    return purchaseProduct(productId, conversionJourneyId: conversionJourneyId);
  }

  /// The "50% off first year" promo is an introductory offer on the annual
  /// subscription, so this buys the same product as [SubscriptionSelection.annual].
  Future<PurchaseFlowResult> purchaseDiscountAnnual() {
    return purchaseProduct(IapProductIds.annual);
  }

  Future<PurchaseFlowResult> purchaseProduct(
    String productId, {
    String? conversionJourneyId,
  }) async {
    if (!NetworkStatus.lastKnownOnline) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.featureNeedsInternet,
      );
    }

    if (!_isAvailable) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.iapBillingUnavailable,
      );
    }

    if (_products.isEmpty) {
      await loadProducts();
    }

    final product = _products[productId];
    if (product == null) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.iapProductNotFound(productId),
      );
    }

    if (_activePurchaseCompleter != null) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.iapPurchaseInProgress,
      );
    }

    _activePurchaseCompleter = Completer<PurchaseFlowResult>();
    _activeConversionJourneyId = conversionJourneyId;
    _heartBalanceBeforeActivePurchase = _homeViewModel.lives;

    _logPurchaseLifecycleEvent(
      productId,
      heartsEvent: AnalyticsEvents.heartPurchaseStarted,
      subscriptionEvent: AnalyticsEvents.purchaseStarted,
      extraParams: {
        if (IapProductIds.isHeartsProduct(productId))
          AnalyticsParams.heartBalanceBefore: _heartBalanceBeforeActivePurchase,
      },
    );

    final started = await _startPurchase(product);
    if (!started) {
      _logPurchaseLifecycleEvent(
        productId,
        heartsEvent: AnalyticsEvents.heartPurchaseFailed,
        subscriptionEvent: AnalyticsEvents.purchaseFailed,
        extraParams: {
          AnalyticsParams.errorType: 'iap',
          AnalyticsParams.errorCode: 'start_failed',
        },
      );
      _clearActivePurchase();
      return PurchaseFlowResult(
        success: false,
        message: _l10n.iapCouldNotStart,
      );
    }

    return _activePurchaseCompleter!.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        _logPurchaseLifecycleEvent(
          productId,
          heartsEvent: AnalyticsEvents.heartPurchaseFailed,
          subscriptionEvent: AnalyticsEvents.purchaseFailed,
          extraParams: {
            AnalyticsParams.errorType: 'iap',
            AnalyticsParams.errorCode: 'timeout',
          },
        );
        _clearActivePurchase();
        return PurchaseFlowResult(
          success: false,
          message: _l10n.iapPurchaseTimedOut,
        );
      },
    );
  }

  Future<bool> _startPurchase(ProductDetails product) async {
    final purchaseParam = _buildPurchaseParam(product);
    if (IapProductIds.isConsumable(product.id)) {
      return _iap.buyConsumable(purchaseParam: purchaseParam);
    }
    return _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  PurchaseParam _buildPurchaseParam(ProductDetails product) {
    if (product is GooglePlayProductDetails) {
      final offer = _subscriptionOffer(product);
      final sku = offer == null
          ? null
          : IapProductIds.idForPlayBasePlan(offer.basePlanId);
      return GooglePlayPurchaseParam(
        productDetails: product,
        offerToken: (sku == null ? null : _trialOfferTokens[sku]) ??
            product.offerToken,
      );
    }
    return PurchaseParam(productDetails: product);
  }

  Future<PurchaseFlowResult> restorePurchases({
    String? conversionJourneyId,
  }) async {
    if (!NetworkStatus.lastKnownOnline) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.featureNeedsInternet,
      );
    }

    if (!_isAvailable) {
      return PurchaseFlowResult(
        success: false,
        message: _l10n.iapBillingUnavailable,
      );
    }

    await _iap.restorePurchases();
    await Future<void>.delayed(const Duration(seconds: 2));

    if (_localStorage.isPremium) {
      AnalyticsService.instance.log(AnalyticsEvents.restorePurchaseSucceeded, {
        AnalyticsParams.conversionJourneyId: conversionJourneyId,
      });
      return PurchaseFlowResult(
        success: true,
        isPremium: true,
        message: _l10n.iapPremiumRestored,
      );
    }

    AnalyticsService.instance.log(AnalyticsEvents.restorePurchaseFailed, {
      AnalyticsParams.conversionJourneyId: conversionJourneyId,
      AnalyticsParams.errorType: 'restore',
      AnalyticsParams.errorCode: 'no-active-subscription',
    });
    return PurchaseFlowResult(
      success: false,
      message: _l10n.iapNoSubscriptionToRestore,
    );
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) continue;

      if (purchase.status == PurchaseStatus.error) {
        _logPurchaseLifecycleEvent(
          purchase.productID,
          heartsEvent: AnalyticsEvents.heartPurchaseFailed,
          subscriptionEvent: AnalyticsEvents.purchaseFailed,
          extraParams: {
            AnalyticsParams.errorType: 'iap',
            AnalyticsParams.errorCode: purchase.error?.code ?? 'unknown',
          },
        );
        _completeActivePurchase(
          PurchaseFlowResult(
            success: false,
            message: _l10n.iapPurchaseFailed,
          ),
        );
        continue;
      }

      if (purchase.status == PurchaseStatus.canceled) {
        _logPurchaseLifecycleEvent(
          purchase.productID,
          heartsEvent: AnalyticsEvents.heartPurchaseCancelled,
          subscriptionEvent: AnalyticsEvents.purchaseCancelled,
        );
        _completeActivePurchase(
          PurchaseFlowResult(
            success: false,
            message: _l10n.iapPurchaseCanceled,
            isCanceled: true,
          ),
        );
        continue;
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final result = await _deliverProduct(purchase);
        _completeActivePurchase(result);
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  Future<PurchaseFlowResult> _deliverProduct(PurchaseDetails purchase) async {
    final productId = purchase.productID;

    if (IapProductIds.isHeartsProduct(productId)) {
      final hearts = IapProductIds.heartsForProductId(productId);
      // Persist the entitlement first — purchase_success must reflect a
      // real, saved balance change, not just the store's callback.
      await _homeViewModel.addHearts(hearts);
      _logPurchaseLifecycleEvent(
        productId,
        heartsEvent: AnalyticsEvents.heartPurchaseSuccess,
        subscriptionEvent: AnalyticsEvents.purchaseSuccess,
        extraParams: {
          AnalyticsParams.heartBalanceBefore: _heartBalanceBeforeActivePurchase,
          AnalyticsParams.heartBalanceAfter: _homeViewModel.lives,
        },
      );
      return PurchaseFlowResult(
        success: true,
        heartsAdded: hearts,
        message: _l10n.heartsAddedTitle(hearts),
      );
    }

    if (IapProductIds.isPremiumProduct(productId)) {
      await _localStorage.setPremiumActive(
        active: true,
        productId: productId,
      );
      AdMobService.instance.refreshAfterEntitlementsChange();
      _logPurchaseLifecycleEvent(
        productId,
        heartsEvent: AnalyticsEvents.heartPurchaseSuccess,
        subscriptionEvent: AnalyticsEvents.purchaseSuccess,
      );
      return PurchaseFlowResult(
        success: true,
        isPremium: true,
        message: _l10n.iapPremiumUnlocked,
      );
    }

    return PurchaseFlowResult(
      success: false,
      message: _l10n.iapUnknownProduct,
    );
  }

  void _completeActivePurchase(PurchaseFlowResult result) {
    final completer = _activePurchaseCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _clearActivePurchase();
  }

  void _clearActivePurchase() {
    _activePurchaseCompleter = null;
    _activeConversionJourneyId = null;
  }

  String _currencySymbol(String currencyCode) {
    return switch (currencyCode.toUpperCase()) {
      'USD' => r'$',
      'EUR' => '€',
      'GBP' => '£',
      'PKR' => 'Rs ',
      _ => '$currencyCode ',
    };
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    _purchaseSubscription = null;
  }
}
