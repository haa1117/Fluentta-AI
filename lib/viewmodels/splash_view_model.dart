import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(this._authRepository);

  final AuthRepository _authRepository;

  // Just enough time to register the brand, not a fixed stall.
  static const _minSplash = Duration(milliseconds: 800);
  // Don't let a slow network hold the app hostage — proceed with local state.
  static const _syncTimeout = Duration(milliseconds: 2500);
  static const _interstitialPreloadTimeout = Duration(milliseconds: 1200);
  static const _interstitialShowTimeout = Duration(seconds: 4);

  bool _isNavigating = false;
  bool get isNavigating => _isNavigating;

  final Stopwatch _stopwatch = Stopwatch()..start();
  int get elapsedMs => _stopwatch.elapsedMilliseconds;

  Future<void> initializeAndNavigate(VoidCallback onComplete) async {
    if (_isNavigating) return;
    _isNavigating = true;

    try {
      final offline = !NetworkStatus.lastKnownOnline;
      const placement = AdPlacement.splashInterstitial;

      if (!offline) {
        AdMobService.instance.preloadInterstitial(placement);
      }

      final results = await Future.wait<dynamic>([
        Future<void>.delayed(_minSplash),
        if (offline)
          Future<void>.value()
        else
          _authRepository.syncCurrentUser().timeout(
                _syncTimeout,
                onTimeout: () {},
              ),
        if (offline)
          Future<bool>.value(false)
        else
          AdMobService.instance.waitForInterstitial(
            placement,
            timeout: _interstitialPreloadTimeout,
          ),
      ]);

      final interstitialReady = results[2] as bool;
      if (interstitialReady && NetworkStatus.lastKnownOnline) {
        await AdMobService.instance.showInterstitial(placement).timeout(
              _interstitialShowTimeout,
              onTimeout: () => false,
            );
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Splash init continued with local state: $error\n$stack');
      }
    } finally {
      onComplete();
    }
  }
}
