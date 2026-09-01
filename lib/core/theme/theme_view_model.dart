import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/theme/app_appearance_mode.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeViewModel(this._localStorage) {
    _mode = AppAppearanceMode.fromStorage(_localStorage.themeMode);
  }

  final LocalStorage _localStorage;
  late AppAppearanceMode _mode;

  AppAppearanceMode get mode => _mode;
  ThemeMode get themeMode => _mode.themeMode;

  Future<void> setMode(AppAppearanceMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await _localStorage.setThemeMode(mode.storageValue);
    notifyListeners();
  }

  String modeLabel(AppLocalizations l10n) {
    return switch (_mode) {
      AppAppearanceMode.system => l10n.systemDefault,
      AppAppearanceMode.light => l10n.lightMode,
      AppAppearanceMode.dark => l10n.darkMode,
    };
  }
}
