import 'package:flutter/widgets.dart';

/// Runs [onFirstFrame] once when this widget is first inserted.
///
/// Used so `screen_view` / `*_viewed` fire when a screen's content is
/// actually mounted, and again if the user leaves and comes back.
class AnalyticsFirstFrame extends StatefulWidget {
  const AnalyticsFirstFrame({
    super.key,
    required this.onFirstFrame,
    required this.child,
  });

  final VoidCallback onFirstFrame;
  final Widget child;

  @override
  State<AnalyticsFirstFrame> createState() => _AnalyticsFirstFrameState();
}

class _AnalyticsFirstFrameState extends State<AnalyticsFirstFrame> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onFirstFrame();
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
