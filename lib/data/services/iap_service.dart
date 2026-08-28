import 'dart:async';

import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/iap/iap_product_ids.dart';
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

  bool _isAvailable = false;
  bool _isLoadingProducts = false;

  bool get isStoreAvailable => _isAvailable;
  bool get isLoadingProducts => _isLoadingProducts;

  Completer<PurchaseFlowResult>? _activePurchaseCompleter;

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    _purchaseSubscription ??= _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (_) {
        _completeActivePurchase(
          const PurchaseFlowResult(
            success: false,
            message: 'Purchase failed. Please try again.',
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
    _products
      ..clear()
      ..addEntries(response.productDetails.map((p) => MapEntry(p.id, p)));
    _isLoadingProducts = false;

    if (response.notFoundIDs.isNotEmpty) {
      // Products not configured in Play Console yet — fallbacks still work.
    }
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
    SubscriptionSelection selection,
  ) async {
    final productId = IapProductIds.idForSelection(selection);
    if (productId == null) {
      return const PurchaseFlowResult(
        success: false,
        message: 'Invalid product selection.',
      );
    }
    return purchaseProduct(productId);
  }

  Future<PurchaseFlowResult> purchaseDiscountAnnual() {
    return purchaseProduct(IapProductIds.annualDiscount);
  }

  Future<PurchaseFlowResult> purchaseProduct(String productId) async {
    if (!_isAvailable) {
      return const PurchaseFlowResult(
        success: false,
        message: 'Google Play Billing is not available on this device.',
      );
    }

    if (_products.isEmpty) {
      await loadProducts();
    }

    final product = _products[productId];
    if (product == null) {
      return PurchaseFlowResult(
        success: false,
        message: 'Product not found in Play Store: $productId',
      );
    }

    if (_activePurchaseCompleter != null) {
      return const PurchaseFlowResult(
        success: false,
        message: 'Another purchase is already in progress.',
      );
    }

    _activePurchaseCompleter = Completer<PurchaseFlowResult>();

    final started = await _startPurchase(product);
    if (!started) {
      _clearActivePurchase();
      return const PurchaseFlowResult(
        success: false,
        message: 'Could not start purchase.',
      );
    }

    return _activePurchaseCompleter!.future.timeout(
      const Duration(minutes: 3),
      onTimeout: () {
        _clearActivePurchase();
        return const PurchaseFlowResult(
          success: false,
          message: 'Purchase timed out.',
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
      return GooglePlayPurchaseParam(
        productDetails: product,
        offerToken: product.offerToken,
      );
    }
    return PurchaseParam(productDetails: product);
  }

  Future<PurchaseFlowResult> restorePurchases() async {
    if (!_isAvailable) {
      return const PurchaseFlowResult(
        success: false,
        message: 'Google Play Billing is not available on this device.',
      );
    }

    await _iap.restorePurchases();
    await Future<void>.delayed(const Duration(seconds: 2));

    if (_localStorage.isPremium) {
      return const PurchaseFlowResult(
        success: true,
        isPremium: true,
        message: 'Premium access restored.',
      );
    }

    return const PurchaseFlowResult(
      success: false,
      message: 'No active subscription found to restore.',
    );
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) continue;

      if (purchase.status == PurchaseStatus.error) {
        _completeActivePurchase(
          PurchaseFlowResult(
            success: false,
            message: purchase.error?.message ?? 'Purchase failed.',
          ),
        );
        continue;
      }

      if (purchase.status == PurchaseStatus.canceled) {
        _completeActivePurchase(
          const PurchaseFlowResult(
            success: false,
            message: 'Purchase canceled.',
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
      await _homeViewModel.addHearts(hearts);
      return PurchaseFlowResult(
        success: true,
        heartsAdded: hearts,
        message: '$hearts hearts added.',
      );
    }

    if (IapProductIds.isPremiumProduct(productId)) {
      await _localStorage.setPremiumActive(
        active: true,
        productId: productId,
      );
      AdMobService.instance.refreshAfterEntitlementsChange();
      return const PurchaseFlowResult(
        success: true,
        isPremium: true,
        message: 'Premium unlocked.',
      );
    }

    return const PurchaseFlowResult(
      success: false,
      message: 'Unknown product purchased.',
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
