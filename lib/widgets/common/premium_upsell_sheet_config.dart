import 'package:flutter/material.dart';

/// Customizable content for the shared premium upsell bottom sheet.
class PremiumUpsellSheetConfig {
  const PremiumUpsellSheetConfig({
    this.title,
    this.subtitle,
    this.sectionLabel,
    this.showWatchAd = true,
    this.imageAsset,
    this.image,
    this.imageHeight,
  });

  /// Headline (defaults to out-of-hearts copy when null).
  final String? title;

  /// Body text under the headline.
  final String? subtitle;

  /// Small caps label above the action cards (e.g. GET MORE HEARTS).
  final String? sectionLabel;

  /// When false, the Watch Ad card is hidden.
  final bool showWatchAd;

  /// Asset path for the hero image (e.g. `AppAssets.outOfHearthBird`).
  /// Ignored when [image] is set.
  final String? imageAsset;

  /// Custom hero widget instead of [imageAsset].
  final Widget? image;

  /// Hero image height. Defaults to 140 logical px when null.
  final double? imageHeight;

  PremiumUpsellSheetConfig copyWith({
    String? title,
    String? subtitle,
    String? sectionLabel,
    bool? showWatchAd,
    String? imageAsset,
    Widget? image,
    double? imageHeight,
  }) {
    return PremiumUpsellSheetConfig(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      sectionLabel: sectionLabel ?? this.sectionLabel,
      showWatchAd: showWatchAd ?? this.showWatchAd,
      imageAsset: imageAsset ?? this.imageAsset,
      image: image ?? this.image,
      imageHeight: imageHeight ?? this.imageHeight,
    );
  }
}
