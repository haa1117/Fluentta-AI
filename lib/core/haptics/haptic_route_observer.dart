import 'package:flutter/widgets.dart';
import 'package:fluentta_ai/core/haptics/haptic_service.dart';

/// Gives every dialog, bottom sheet and popup a light haptic tick when it
/// opens, so individual call sites don't each have to remember to.
class HapticRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute) {
      HapticService.light();
    }
  }
}
