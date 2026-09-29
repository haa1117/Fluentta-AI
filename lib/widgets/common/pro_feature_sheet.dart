import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart';
import 'package:fluentta_ai/widgets/common/premium_upsell_sheet_config.dart';

/// Pro-locked feature upsell — same UI as the out-of-hearts sheet, custom copy.
///
/// showWatchAd defaults to false: the sheet's "Watch Ad" action is hardwired
/// to grant Hearts (onWatchAd -> home.watchAdForHearts() in
/// out_of_hearts_bottom_sheet.dart), which does nothing to unlock a
/// Pro-locked feature — showing it here was misleading.
Future<void> showProFeatureSheet(
  BuildContext context, {
  required String title,
  required String message,
  bool showWatchAd = false,
  String? sectionLabel,
  String? imageAsset,
  Widget? image,
  double? imageHeight,
  VoidCallback? onShown,
  VoidCallback? onGoUnlimitedTapped,
  VoidCallback? onDismissedWithoutAction,
}) {
  return showPremiumUpsellBottomSheet(
    context,
    config: PremiumUpsellSheetConfig(
      title: title,
      subtitle: message,
      sectionLabel: sectionLabel ?? context.l10n.upgradeToPro,
      showWatchAd: showWatchAd,
      imageAsset: imageAsset,
      image: image,
      imageHeight: imageHeight,
    ),
    onShown: onShown,
    onGoUnlimitedTapped: onGoUnlimitedTapped,
    onDismissedWithoutAction: onDismissedWithoutAction,
  );
}
