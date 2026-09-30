import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class HapticService {
  HapticService._();

  static Future<void> light() => HapticFeedback.lightImpact();

  static Future<void> medium() => HapticFeedback.mediumImpact();

  static Future<void> heavy() => HapticFeedback.heavyImpact();

  static Future<void> selection() => HapticFeedback.selectionClick();

  /// Wraps a tap callback so it fires a light haptic first. Returns null for a
  /// null callback so disabled buttons stay disabled.
  static VoidCallback? wrap(VoidCallback? callback) {
    if (callback == null) return null;
    return () {
      light();
      callback();
    };
  }

  /// Same as [wrap] for value callbacks (switches, checkboxes) — uses the
  /// softer selection tick.
  static ValueChanged<T>? wrapValue<T>(ValueChanged<T>? callback) {
    if (callback == null) return null;
    return (value) {
      selection();
      callback(value);
    };
  }
}
