export 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart'
    show OutOfHeartsBottomSheet, showOutOfHeartsBottomSheet;

import 'package:flutter/material.dart';
import 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart';

/// Backward-compatible alias — opens the reusable out-of-hearts bottom sheet.
/// Used exclusively from Open Chat Practice, so the Hearts-recovery
/// analytics context is fixed to the AI Chat feature/blocked-action.
Future<void> showOutOfHeartsDialog(BuildContext context) {
  return showOutOfHeartsBottomSheet(
    context,
    sourceScreen: 'ai_chat',
    featureContext: 'ai_chat',
    blockedAction: 'submit_ai_chat_message',
  );
}
