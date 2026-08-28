import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/ad_unit_ids.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/ads_remote_config.dart';
import 'package:fluentta_ai/data/repositories/ads_config_repository.dart';

/// Central AdMob manager: singleton init, Firestore toggles, preload pools,
/// show-rate / min-interval gating, and rewarded display.
class AdMobService extends ChangeNotifier {
  AdMobService._();

  static final AdMobService instance = AdMobService._();

  static const int _maxPoolSize = 2;

  final AdsConfigRepository _configRepository = AdsConfigRepository();
  final Random _random = Random();

  LocalStorage? _localStorage;
  AdsRemoteConfig _config = AdsRemoteConfig.defaults();
  bool _initialized = false;

  final Map<AdPlacement, List<BannerAd>> _bannerPool = {};
  final Map<AdPlacement, List<NativeAd>> _nativePool = {};
  final Map<AdPlacement, RewardedAd?> _rewardedCache = {};
  final Map<AdPlacement, InterstitialAd?> _interstitialCache = {};
  final Map<AdPlacement, DateTime> _lastShownAt = {};
  final Map<AdPlacement, bool> _showRateDecisions = {};
  final Map<AdPlacement, bool> _loadingBanner = {};
  final Map<AdPlacement, bool> _loadingNative = {};
  final Map<AdPlacement, bool> _loadingRewarded = {};
  final Map<AdPlacement, bool> _loadingInterstitial = {};
  final Map<AdPlacement, Future<void>> _interstitialLoadTasks = {};

  AdsRemoteConfig get config => _config;
  bool get isInitialized => _initialized;

  bool get _isPremiumUser => _localStorage?.isPremium ?? false;

  Future<void> initialize({required LocalStorage localStorage}) async {
    if (kIsWeb || _initialized) return;

    _localStorage = localStorage;

    if (kDebugMode) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: const <String>['EMULATOR'],
        ),
      );
    }

    await MobileAds.instance.initialize();
    _config = await _configRepository.fetch();

    if (kDebugMode) {
      debugPrint('AdMob initialized. masterEnabled=${_config.masterEnabled}');
      debugPrint('Using test ad units: ${AdUnitIds.useTestIds}');
      for (final placement in AdPlacement.values) {
        final settings = _config.settingsFor(placement);
        debugPrint(
          '${placement.firestoreKey}: enabled=${settings.enabled}, '
          'showRate=${settings.showRate}',
        );
      }
    }

    _configRepository.startListening((updated) {
      _config = updated;
      _showRateDecisions.clear();
      notifyListeners();
      _preloadEnabledPlacements();
    });

    _initialized = true;
    notifyListeners();
    if (!_isPremiumUser) {
      unawaited(_preloadEnabledPlacements());
    }
  }

  /// Call when Pro status changes (purchase, restore, debug toggle, logout).
  void refreshAfterEntitlementsChange() {
    if (!_initialized) return;

    if (_isPremiumUser) {
      _disposeAllAds();
    }
    _showRateDecisions.clear();
    notifyListeners();

    if (!_isPremiumUser) {
      unawaited(_preloadEnabledPlacements());
    }
  }

  void disposeService() {
    _configRepository.dispose();
    _disposeAllAds();
    _initialized = false;
  }

  /// Whether this placement should render an ad slot (Firestore + premium + rate).
  bool shouldDisplay(AdPlacement placement) {
    if (kIsWeb || !_initialized) return false;
    if (!_config.masterEnabled) return false;
    if (_isPremiumUser) return false;

    final settings = _config.settingsFor(placement);
    if (!settings.enabled) return false;

    if (!kDebugMode) {
      final showAllowed = _showRateDecisions.putIfAbsent(
        placement,
        () => _passesShowRate(settings.showRate),
      );
      if (!showAllowed) return false;
      if (!_passesMinInterval(placement, settings.minIntervalSeconds)) {
        return false;
      }
    }

    return true;
  }

  /// Debug helper — why a placement is hidden.
  String displayBlockReason(AdPlacement placement) {
    if (kIsWeb) return 'web platform';
    if (!_initialized) return 'not initialized';
    if (!_config.masterEnabled) return 'masterEnabled=false';
    if (_isPremiumUser) return 'premium user';

    final settings = _config.settingsFor(placement);
    if (!settings.enabled) return 'placement disabled in Firestore';

    final showAllowed = _showRateDecisions[placement];
    if (showAllowed == false) return 'showRate blocked';

    if (!_passesMinInterval(placement, settings.minIntervalSeconds)) {
      return 'minInterval active';
    }

    return 'allowed';
  }

  void recordImpression(AdPlacement placement) {
    _lastShownAt[placement] = DateTime.now();
  }

  String unitIdFor(AdPlacement placement) => AdUnitIds.unitId(placement);

  /// Returns a preloaded banner or loads one on demand.
  Future<BannerAd?> acquireBanner(
    AdPlacement placement, {
    required int width,
  }) async {
    if (!shouldDisplay(placement)) return null;

    final pool = _bannerPool[placement];
    if (pool != null && pool.isNotEmpty) {
      final ad = pool.removeAt(0);
      unawaited(_preloadBanner(placement, width: width));
      return ad;
    }

    return _loadBanner(placement, width: width);
  }

  /// Returns a preloaded native ad or loads one on demand.
  Future<NativeAd?> acquireNative(AdPlacement placement) async {
    if (!shouldDisplay(placement)) return null;

    final pool = _nativePool[placement];
    if (pool != null && pool.isNotEmpty) {
      final ad = pool.removeAt(0);
      unawaited(_preloadNative(placement));
      return ad;
    }

    return _loadNative(placement);
  }

  /// Shows a rewarded ad when allowed. Returns true if user earned reward.
  Future<bool> showRewarded(
    AdPlacement placement, {
    required VoidCallback onReward,
  }) async {
    if (!shouldDisplay(placement)) return false;

    var rewarded = _rewardedCache[placement];
    if (rewarded == null) {
      rewarded = await _loadRewarded(placement);
      if (rewarded == null) return false;
    }

    final completer = Completer<bool>();
    var rewardedEarned = false;

    rewarded.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedCache[placement] = null;
        unawaited(_preloadRewarded(placement));
        if (!completer.isCompleted) {
          completer.complete(rewardedEarned);
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          debugPrint('Rewarded show failed [$placement]: $error');
        }
        ad.dispose();
        _rewardedCache[placement] = null;
        unawaited(_preloadRewarded(placement));
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    await rewarded.show(
      onUserEarnedReward: (ad, rewardItem) {
        rewardedEarned = true;
        recordImpression(placement);
        onReward();
      },
    );

    return completer.future;
  }

  /// Starts loading an interstitial if ads are allowed for this placement.
  void preloadInterstitial(AdPlacement placement) {
    if (!shouldDisplay(placement)) return;
    unawaited(_preloadInterstitial(placement));
  }

  /// Waits until interstitial is cached or [timeout] elapses.
  Future<bool> waitForInterstitial(
    AdPlacement placement, {
    required Duration timeout,
  }) async {
    if (!shouldDisplay(placement)) return false;
    if (_interstitialCache[placement] != null) return true;

    try {
      await _preloadInterstitial(placement).timeout(timeout);
    } on TimeoutException {
      if (kDebugMode) {
        debugPrint('Interstitial preload timeout [$placement]');
      }
    }

    return _interstitialCache[placement] != null;
  }

  /// Shows a preloaded interstitial. Returns when dismissed or if show fails.
  Future<bool> showInterstitial(AdPlacement placement) async {
    if (!shouldDisplay(placement)) return false;

    final ad = _interstitialCache.remove(placement);
    if (ad == null) return false;

    final completer = Completer<bool>();

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        recordImpression(placement);
        unawaited(_preloadInterstitial(placement));
        if (!completer.isCompleted) completer.complete(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        if (kDebugMode) {
          debugPrint('Interstitial show failed [$placement]: $error');
        }
        ad.dispose();
        unawaited(_preloadInterstitial(placement));
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    ad.show();
    return completer.future;
  }

  Future<void> _preloadEnabledPlacements() async {
    if (_isPremiumUser) return;

    for (final placement in AdPlacement.values) {
      if (!_config.settingsFor(placement).enabled) continue;
      if (!_config.masterEnabled) continue;

      if (placement.isBanner) {
        unawaited(_preloadBanner(placement, width: 360));
      } else if (placement.isNative) {
        unawaited(_preloadNative(placement));
      } else if (placement.isRewarded) {
        unawaited(_preloadRewarded(placement));
      } else if (placement.isInterstitial) {
        unawaited(_preloadInterstitial(placement));
      }
    }
  }

  Future<void> _preloadBanner(AdPlacement placement, {required int width}) async {
    if (_loadingBanner[placement] == true) return;
    final pool = _bannerPool.putIfAbsent(placement, () => []);
    if (pool.length >= _maxPoolSize) return;
    if (!_config.settingsFor(placement).enabled) return;

    _loadingBanner[placement] = true;
    final ad = await _loadBanner(placement, width: width);
    _loadingBanner[placement] = false;

    if (ad != null && pool.length < _maxPoolSize) {
      pool.add(ad);
    } else {
      ad?.dispose();
    }
  }

  Future<void> _preloadNative(AdPlacement placement) async {
    if (_loadingNative[placement] == true) return;
    final pool = _nativePool.putIfAbsent(placement, () => []);
    if (pool.length >= _maxPoolSize) return;
    if (!_config.settingsFor(placement).enabled) return;

    _loadingNative[placement] = true;
    final ad = await _loadNative(placement);
    _loadingNative[placement] = false;

    if (ad != null && pool.length < _maxPoolSize) {
      pool.add(ad);
    } else {
      ad?.dispose();
    }
  }

  Future<void> _preloadRewarded(AdPlacement placement) async {
    if (_loadingRewarded[placement] == true) return;
    if (_rewardedCache[placement] != null) return;
    if (!_config.settingsFor(placement).enabled) return;

    _loadingRewarded[placement] = true;
    final ad = await _loadRewarded(placement);
    _loadingRewarded[placement] = false;
    if (ad != null) {
      _rewardedCache[placement] = ad;
    }
  }

  Future<void> _preloadInterstitial(AdPlacement placement) async {
    if (_interstitialCache[placement] != null) return;

    final existing = _interstitialLoadTasks[placement];
    if (existing != null) {
      await existing;
      return;
    }

    if (!_config.settingsFor(placement).enabled) return;

    final task = _loadInterstitialIntoCache(placement);
    _interstitialLoadTasks[placement] = task;
    try {
      await task;
    } finally {
      _interstitialLoadTasks.remove(placement);
    }
  }

  Future<void> _loadInterstitialIntoCache(AdPlacement placement) async {
    if (_interstitialCache[placement] != null) return;

    _loadingInterstitial[placement] = true;
    final ad = await _loadInterstitial(placement);
    _loadingInterstitial[placement] = false;
    if (ad != null) {
      _interstitialCache[placement] = ad;
    }
  }

  Future<BannerAd?> _loadBanner(
    AdPlacement placement, {
    required int width,
  }) async {
    final anchoredSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    final adSize = anchoredSize ?? AdSize.banner;
    final unitId = unitIdFor(placement);

    if (kDebugMode) {
      debugPrint('Loading banner [$placement] unitId=$unitId size=$adSize');
    }

    final completer = Completer<BannerAd?>();
    late final BannerAd bannerAd;
    bannerAd = BannerAd(
      adUnitId: unitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (kDebugMode) {
            debugPrint('Banner loaded [$placement]');
          }
          if (!completer.isCompleted) completer.complete(bannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            debugPrint('Banner load failed [$placement]: $error');
          }
          ad.dispose();
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    bannerAd.load();
    return completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        if (kDebugMode) {
          debugPrint('Banner load timeout [$placement]');
        }
        bannerAd.dispose();
        return null;
      },
    );
  }

  Future<NativeAd?> _loadNative(AdPlacement placement) async {
    final completer = Completer<NativeAd?>();
    late final NativeAd nativeAd;
    nativeAd = NativeAd(
      adUnitId: unitIdFor(placement),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: const Color(0xFFF5F7FA),
        cornerRadius: 12,
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (!completer.isCompleted) completer.complete(nativeAd);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            debugPrint('Native load failed [$placement]: $error');
          }
          ad.dispose();
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    await nativeAd.load();
    return completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        nativeAd.dispose();
        return null;
      },
    );
  }

  Future<RewardedAd?> _loadRewarded(AdPlacement placement) async {
    final completer = Completer<RewardedAd?>();
    await RewardedAd.load(
      adUnitId: unitIdFor(placement),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('Rewarded load failed [$placement]: $error');
          }
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    return completer.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => null,
    );
  }

  Future<InterstitialAd?> _loadInterstitial(AdPlacement placement) async {
    final completer = Completer<InterstitialAd?>();

    if (kDebugMode) {
      debugPrint(
        'Loading interstitial [$placement] unitId=${unitIdFor(placement)}',
      );
    }

    await InterstitialAd.load(
      adUnitId: unitIdFor(placement),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            debugPrint('Interstitial loaded [$placement]');
          }
          if (!completer.isCompleted) completer.complete(ad);
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('Interstitial load failed [$placement]: $error');
          }
          if (!completer.isCompleted) completer.complete(null);
        },
      ),
    );

    return completer.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () => null,
    );
  }

  bool _passesShowRate(double rate) {
    if (rate >= 1) return true;
    if (rate <= 0) return false;
    return _random.nextDouble() <= rate;
  }

  bool _passesMinInterval(AdPlacement placement, int minSeconds) {
    if (minSeconds <= 0) return true;
    final last = _lastShownAt[placement];
    if (last == null) return true;
    return DateTime.now().difference(last).inSeconds >= minSeconds;
  }

  void _disposeAllAds() {
    for (final pool in _bannerPool.values) {
      for (final ad in pool) {
        ad.dispose();
      }
    }
    _bannerPool.clear();

    for (final pool in _nativePool.values) {
      for (final ad in pool) {
        ad.dispose();
      }
    }
    _nativePool.clear();

    for (final ad in _rewardedCache.values) {
      ad?.dispose();
    }
    _rewardedCache.clear();

    for (final ad in _interstitialCache.values) {
      ad?.dispose();
    }
    _interstitialCache.clear();
  }
}
