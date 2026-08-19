export 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart'
    show OutOfHeartsBottomSheet, showOutOfHeartsBottomSheet;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart';

/// Backward-compatible alias — opens the reusable out-of-hearts bottom sheet.
Future<void> showOutOfHeartsDialog(BuildContext context) {
  return showOutOfHeartsBottomSheet(context);
}
