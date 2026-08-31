import 'package:flutter/material.dart';

enum AppAppearanceMode {
  system,
  light,
  dark;

  ThemeMode get themeMode => switch (this) {
        AppAppearanceMode.system => ThemeMode.system,
        AppAppearanceMode.light => ThemeMode.light,
        AppAppearanceMode.dark => ThemeMode.dark,
      };

  static AppAppearanceMode fromStorage(String? value) {
    return switch (value) {
      'light' => AppAppearanceMode.light,
      'dark' => AppAppearanceMode.dark,
      _ => AppAppearanceMode.system,
    };
  }

  String get storageValue => switch (this) {
        AppAppearanceMode.system => 'system',
        AppAppearanceMode.light => 'light',
        AppAppearanceMode.dark => 'dark',
      };
}
