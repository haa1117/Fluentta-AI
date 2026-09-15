import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(this._authRepository);

  final AuthRepository _authRepository;

  // Just enough time to register the brand, not a fixed stall.
  static const _minSplash = Duration(milliseconds: 800);
  // Don't let a slow network hold the app hostage — proceed with local state.
  static const _syncTimeout = Duration(milliseconds: 2500);
  static const _interstitialPreloadTimeout = Duration(milliseconds: 1200);

  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  Future<void> initializeAndNavigate(VoidCallback onComplete) async {
    if (_isNavigating) return;
    _isNavigating = true;

    const placement = AdPlacement.splashInterstitial;
    AdMobService.instance.preloadInterstitial(placement);

    final results = await Future.wait<dynamic>([
      Future<void>.delayed(_minSplash),
      _authRepository
          .syncCurrentUser()
          .timeout(_syncTimeout, onTimeout: () {}),
      AdMobService.instance.waitForInterstitial(
        placement,
        timeout: _interstitialPreloadTimeout,
      ),
    ]);

    final interstitialReady = results[2] as bool;
    if (interstitialReady) {
      await AdMobService.instance.showInterstitial(placement);
    }

    onComplete();
  }
}
