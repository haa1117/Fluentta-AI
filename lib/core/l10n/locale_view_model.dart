import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// App-wide locale state synced with [LocalStorage.selectedLanguage].
class LocaleViewModel extends ChangeNotifier {
  LocaleViewModel(this._localStorage) {
    _locale = _localeFromCode(_localStorage.selectedLanguage ?? 'en');
  }

  static const _supportedCodes = {'en', 'es', 'fr', 'ur'};

  final LocalStorage _localStorage;
  late Locale _locale;

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  AppLocalizations get strings => lookupAppLocalizations(_locale);

  Future<void> setLocale(String code) async {
    final normalized = normalizeLanguageCode(code);
    if (_locale.languageCode == normalized &&
        _localStorage.selectedLanguage == normalized) {
      return;
    }
    await _localStorage.setSelectedLanguage(normalized);
    _locale = _localeFromCode(normalized);
    notifyListeners();
  }

  void reloadFromStorage() {
    _locale = _localeFromCode(_localStorage.selectedLanguage ?? 'en');
    notifyListeners();
  }

  Locale _localeFromCode(String code) => Locale(normalizeLanguageCode(code));

  static String normalizeLanguageCode(String code) {
    final trimmed = code.trim().toLowerCase();
    if (trimmed.isEmpty) return 'en';
    final primary = trimmed.split(RegExp(r'[-_]')).first;
    if (_supportedCodes.contains(primary)) return primary;
    return switch (primary) {
      'spanish' || 'espanol' || 'español' => 'es',
      'french' || 'francais' || 'français' => 'fr',
      'urdu' => 'ur',
      'english' => 'en',
      _ => 'en',
    };
  }
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n {
    final fromApp = Localizations.of<AppLocalizations>(this, AppLocalizations);
    if (fromApp != null) return fromApp;
    return Provider.of<LocaleViewModel>(this, listen: false).strings;
  }
}

AppLocalizations l10nFor(String languageCode) {
  return lookupAppLocalizations(
    Locale(LocaleViewModel.normalizeLanguageCode(languageCode)),
  );
}

String localizedLanguageName(AppLocalizations l10n, String code) {
  return switch (LocaleViewModel.normalizeLanguageCode(code)) {
    'ur' => l10n.languageUrdu,
    'en' => l10n.languageEnglish,
    'es' => l10n.languageSpanish,
    'fr' => l10n.languageFrench,
    _ => l10n.languageEnglish,
  };
}
