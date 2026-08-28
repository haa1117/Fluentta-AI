import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/constants/app_sizes.dart';
import 'package:fluentta_ai/core/theme/app_colors.dart';

/// Standard banner slot — wire on Home, Learn, Setup, Role Play screens.
class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({
    super.key,
    required this.placement,
    this.fallbackHeight = 50,
  });

  final AdPlacement placement;
  final double fallbackHeight;

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _loading = false;
  int _retryCount = 0;
  Timer? _retryTimer;

  static const _maxRetries = 6;

  @override
  void initState() {
    super.initState();
    AdMobService.instance.addListener(_onServiceUpdated);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAd());
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    AdMobService.instance.removeListener(_onServiceUpdated);
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onServiceUpdated() {
    if (!AdMobService.instance.shouldDisplay(widget.placement)) {
      _retryTimer?.cancel();
      _bannerAd?.dispose();
      _bannerAd = null;
      if (mounted) setState(() {});
      return;
    }
    if (_bannerAd == null && !_loading) {
      _loadAd();
    }
  }

  void _scheduleRetry() {
    if (_retryCount >= _maxRetries || !mounted) return;
    _retryCount += 1;
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(seconds: _retryCount * 2), () {
      if (mounted && _bannerAd == null && !_loading) {
        _loadAd();
      }
    });
  }

  Future<void> _loadAd() async {
    if (_loading || !mounted) return;

    if (!AdMobService.instance.isInitialized) {
      _scheduleRetry();
      return;
    }

    if (!AdMobService.instance.shouldDisplay(widget.placement)) {
      if (kDebugMode) {
        debugPrint(
          'AdBannerWidget skipped [${widget.placement.name}]: '
          '${AdMobService.instance.displayBlockReason(widget.placement)}',
        );
      }
      return;
    }

    final width = MediaQuery.sizeOf(context).width.truncate();
    setState(() => _loading = true);

    final ad = await AdMobService.instance.acquireBanner(
      widget.placement,
      width: width,
    );

    if (!mounted) {
      ad?.dispose();
      return;
    }

    setState(() {
      _loading = false;
      _bannerAd?.dispose();
      _bannerAd = ad;
    });

    if (ad != null) {
      _retryCount = 0;
      AdMobService.instance.recordImpression(widget.placement);
    } else {
      if (kDebugMode) {
        debugPrint('AdBannerWidget load failed [${widget.placement.name}]');
      }
      _scheduleRetry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdMobService.instance,
      builder: (context, _) {
        final service = AdMobService.instance;
        if (!service.isInitialized ||
            !service.shouldDisplay(widget.placement)) {
          return const SizedBox.shrink();
        }

        final ad = _bannerAd;
        if (ad != null) {
          return SizedBox(
            width: double.infinity,
            height: ad.size.height.toDouble(),
            child: AdWidget(ad: ad),
          );
        }

        return SizedBox(
          width: double.infinity,
          height: widget.fallbackHeight,
          child: _loading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.adBackground,
                    borderRadius: BorderRadius.circular(AppSizes.adRadius),
                    border: Border.all(color: AppColors.adBorder),
                  ),
                ),
        );
      },
    );
  }
}

/// Native template slot — used on lesson complete and similar screens.
class AdNativeWidget extends StatefulWidget {
  const AdNativeWidget({
    super.key,
    required this.placement,
    this.height,
  });

  final AdPlacement placement;
  final double? height;

  @override
  State<AdNativeWidget> createState() => _AdNativeWidgetState();
}

class _AdNativeWidgetState extends State<AdNativeWidget> {
  NativeAd? _nativeAd;
  bool _loading = false;
  int _retryCount = 0;
  Timer? _retryTimer;

  static const _maxRetries = 4;

  @override
  void initState() {
    super.initState();
    AdMobService.instance.addListener(_onServiceUpdated);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAd());
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    AdMobService.instance.removeListener(_onServiceUpdated);
    _nativeAd?.dispose();
    super.dispose();
  }

  void _onServiceUpdated() {
    if (!AdMobService.instance.shouldDisplay(widget.placement)) {
      _retryTimer?.cancel();
      _nativeAd?.dispose();
      _nativeAd = null;
      if (mounted) setState(() {});
      return;
    }
    if (_nativeAd == null && !_loading) {
      _loadAd();
    }
  }

  void _scheduleRetry() {
    if (_retryCount >= _maxRetries || !mounted) return;
    _retryCount += 1;
    _retryTimer?.cancel();
    _retryTimer = Timer(Duration(seconds: _retryCount * 2), () {
      if (mounted && _nativeAd == null && !_loading) {
        _loadAd();
      }
    });
  }

  Future<void> _loadAd() async {
    if (_loading) return;

    if (!AdMobService.instance.isInitialized) {
      _scheduleRetry();
      return;
    }

    if (!AdMobService.instance.shouldDisplay(widget.placement)) {
      return;
    }

    setState(() => _loading = true);
    final ad = await AdMobService.instance.acquireNative(widget.placement);
    if (!mounted) {
      ad?.dispose();
      return;
    }

    setState(() {
      _loading = false;
      _nativeAd?.dispose();
      _nativeAd = ad;
    });

    if (ad != null) {
      _retryCount = 0;
      AdMobService.instance.recordImpression(widget.placement);
    } else {
      _scheduleRetry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AdMobService.instance,
      builder: (context, _) {
        final service = AdMobService.instance;
        if (!service.isInitialized ||
            !service.shouldDisplay(widget.placement)) {
          return const SizedBox.shrink();
        }

        final ad = _nativeAd;
        final height = widget.height ?? AppSizes.adPlaceholderHeight;

        if (ad == null) {
          return SizedBox(width: double.infinity, height: height);
        }

        return SizedBox(
          width: double.infinity,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.adRadius),
            child: AdWidget(ad: ad),
          ),
        );
      },
    );
  }
}
