import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/utils/snackbar_helper.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';
import 'package:provider/provider.dart';

/// Runs [complete], then replaces the lesson route with [buildScreen].
///
/// If [complete] throws, [onFailed] is invoked so the caller can re-enable
/// Finish Lesson — otherwise `_isCompleting` stays true forever.
Future<void> completeLessonAndNavigate({
  required BuildContext context,
  required Future<List<String>> Function() complete,
  required Widget Function(List<String> newlyUnlocked, int xpGranted)
      buildScreen,
  required VoidCallback onFailed,
}) async {
  try {
    final unlocked = await complete();
    if (!context.mounted) return;
    final xpGranted =
        context.read<ProgressSyncService>().lastCompletionXpGranted;
    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (_) => buildScreen(unlocked, xpGranted),
      ),
    );
  } catch (error, stack) {
    if (kDebugMode) {
      debugPrint('Lesson completion failed: $error\n$stack');
    }
    onFailed();
    if (context.mounted) {
      SnackbarHelper.showError(context, context.l10n.authErrorGeneric);
    }
  }
}
