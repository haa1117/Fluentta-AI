import 'package:flutter/material.dart';
import 'package:fluentta_ai/viewmodels/profile_view_model.dart';
import 'package:provider/provider.dart';

/// Reschedules daily reminders whenever the app returns to foreground.
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
    }
  }

  Future<void> _refreshReminders() async {
    if (!mounted) return;
    await context.read<ProfileViewModel>().bootstrapNotificationsOnAppOpen();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
