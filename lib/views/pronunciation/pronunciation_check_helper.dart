import 'package:fluentta_ai/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/viewmodels/pronunciation_view_model.dart';
import 'package:fluentta_ai/views/pronunciation/pronunciation_flow.dart';
import 'package:fluentta_ai/widgets/common/out_of_hearts_bottom_sheet.dart';
import 'package:provider/provider.dart';

/// Deducts one heart and opens the recording screen for a pronunciation check.
Future<bool> startPronunciationCheck(
  BuildContext context, {
  bool replaceCurrent = false,
}) async {
  final vm = context.read<PronunciationViewModel>();
  final home = context.read<HomeViewModel>();
  final l10n = context.l10n;

  if (!home.hasUnlimitedHearts && !vm.canAffordCheck) {
    await showOutOfHeartsBottomSheet(context);
    return false;
  }

  final charged = await vm.deductHeartForCheck();
  if (!context.mounted) return false;

  if (!charged) {
    SnackbarHelper.showError(context, l10n.outOfHearts);
    return false;
  }

  if (replaceCurrent) {
    await Navigator.of(context).pushReplacementNamed(
      PronunciationFlow.routeRecording,
    );
  } else {
    await Navigator.of(context).pushNamed(PronunciationFlow.routeRecording);
  }
  return true;
}
