import 'package:flutter/material.dart';
import 'package:fluentta_ai/data/services/pronunciation_assessment_service.dart';
import 'package:fluentta_ai/data/services/text_to_speech_service.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:provider/provider.dart';

/// Reschedules daily reminders whenever the app returns to foreground, and
/// stops any tutor speech / open microphone when the app is backgrounded or
/// closed — audio must never keep playing (or listening) once the learner
/// has left the app.
class NotificationLifecycleWatcher extends StatefulWidget {
  const NotificationLifecycleWatcher({super.key, required this.child});

  final Widget child;

  @override
  State<NotificationLifecycleWatcher> createState() =>
      _NotificationLifecycleWatcherState();
}

class _NotificationLifecycleWatcherState extends State<NotificationLifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refreshReminders();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshReminders();
      return;
    }
    // paused = backgrounded, detached/hidden = torn down or fully hidden.
    // Deliberately NOT `inactive` — that also fires for brief, harmless
    // transitions (a system dialog, the app-switcher preview) where cutting
    // off speech mid-sentence would be jarring for no reason.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _stopAudioInBackground();
    }
  }

  Future<void> _refreshReminders() async {
    if (!mounted) return;
    await context.read<ProfileViewModel>().bootstrapNotificationsOnAppOpen();
  }

  void _stopAudioInBackground() {
    if (!mounted) return;
    context.read<TextToSpeechService>().stop();
    context.read<PronunciationAssessmentService>().cancelListening();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
