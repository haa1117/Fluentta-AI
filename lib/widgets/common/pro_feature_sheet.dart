import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart';
import 'package:fluentta_ai/widgets/common/premium_upsell_sheet_config.dart';

/// Pro-locked feature upsell — same UI as the out-of-hearts sheet, custom copy.
Future<void> showProFeatureSheet(
  BuildContext context, {
  required String title,
  required String message,
  bool showWatchAd = true,
  String? sectionLabel,
  String? imageAsset,
  Widget? image,
  double? imageHeight,
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
  );
}
