import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
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

  // Fire the mic permission check now, before the heart-deduction/navigation
  // work below, so it's already resolved by the time the recording screen
  // asks for it instead of making that screen sit on a blank spinner.
  vm.primeMicrophonePermission();

  // Source/feature screen id is a placeholder: pronunciation screens aren't
  // in this instrumentation pass's scope, so there's no registry id to pull
  // from here yet — 'pronunciation_check' is the PRD feature_context.
  final blockedAction =
      replaceCurrent ? 'retry_pronunciation_check' : 'start_pronunciation_check';
  final checkEntry = replaceCurrent ? 'retry' : 'start';

  if (!home.hasUnlimitedHearts && !vm.canAffordCheck) {
    await showOutOfHeartsBottomSheet(
      context,
      sourceScreen: 'pronunciation_practice',
      featureContext: 'pronunciation_check',
      blockedAction: blockedAction,
    );
    return false;
  }

  final charged = await vm.deductHeartForCheck();
  if (!context.mounted) return false;

  if (!charged) {
    SnackbarHelper.showError(context, l10n.outOfHearts);
    return false;
  }

  home.maybeLogHeartGateRecovery(
    featureContext: 'pronunciation_check',
    blockedAction: blockedAction,
  );

  AnalyticsService.instance.log(AnalyticsEvents.pronunciationCheckStarted, {
    ...vm.phraseAnalyticsParams(),
    AnalyticsParams.checkEntry: checkEntry,
    AnalyticsParams.heartAccessType:
        home.hasUnlimitedHearts ? 'unlimited' : 'metered',
    AnalyticsParams.heartCost: home.hasUnlimitedHearts ? 0 : 1,
  });

  if (replaceCurrent) {
    await Navigator.of(context).pushReplacementNamed(
      PronunciationFlow.routeRecording,
    );
  } else {
    await Navigator.of(context).pushNamed(PronunciationFlow.routeRecording);
  }
  return true;
}
