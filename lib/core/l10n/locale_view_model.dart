import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

/// App-wide locale state synced with [LocalStorage.selectedLanguage].
class LocaleViewModel extends ChangeNotifier {
  LocaleViewModel(this._localStorage) {
    _locale = _localeFromCode(_localStorage.selectedLanguage ?? 'en');
  }

  final LocalStorage _localStorage;
  late Locale _locale;

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  AppLocalizations get strings => lookupAppLocalizations(_locale);

  Future<void> setLocale(String code) async {
    if (_locale.languageCode == code) return;
    await _localStorage.setSelectedLanguage(code);
    _locale = _localeFromCode(code);
    notifyListeners();
  }

  void reloadFromStorage() {
    _locale = _localeFromCode(_localStorage.selectedLanguage ?? 'en');
    notifyListeners();
  }

  Locale _localeFromCode(String code) => Locale(code);
}

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

AppLocalizations l10nFor(String languageCode) {
  return lookupAppLocalizations(Locale(languageCode));
}

String localizedLanguageName(AppLocalizations l10n, String code) {
  return switch (code) {
    'ur' => l10n.languageUrdu,
    'en' => l10n.languageEnglish,
    'es' => l10n.languageSpanish,
    'fr' => l10n.languageFrench,
    _ => l10n.languageEnglish,
  };
}
