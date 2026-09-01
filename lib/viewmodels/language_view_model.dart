import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/language_model.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';

class LanguageViewModel extends ChangeNotifier {
  LanguageViewModel(
    this._localStorage,
    this._userRepository,
    this._authRepository,
    this._localeViewModel,
  ) {
    _selectedLanguageCode = _localStorage.selectedLanguage ?? 'en';
  }

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final LocaleViewModel _localeViewModel;

  String _selectedLanguageCode = 'en';
  String get selectedLanguageCode => _selectedLanguageCode;

  List<LanguageModel> suggestedLanguages(AppLocalizations l10n) => [
        LanguageModel(
          code: 'ur',
          name: l10n.languageUrdu,
          flagEmoji: '🇵🇰',
          subtitle: l10n.recommendedRegion,
          isSuggested: true,
        ),
      ];

  List<LanguageModel> otherLanguages(AppLocalizations l10n) => [
        LanguageModel(
          code: 'en',
          name: l10n.languageEnglish,
          flagEmoji: '🇺🇸',
        ),
        LanguageModel(
          code: 'es',
          name: l10n.languageSpanish,
          flagEmoji: '🇪🇸',
        ),
        LanguageModel(
          code: 'fr',
          name: l10n.languageFrench,
          flagEmoji: '🇫🇷',
        ),
      ];

  void selectLanguage(String code) {
    _selectedLanguageCode = code;
    notifyListeners();
  }

  Future<void> continueWithLanguage(VoidCallback onComplete) async {
    await _localeViewModel.setLocale(_selectedLanguageCode);
    await _syncToFirestoreIfLoggedIn();
    onComplete();
  }

  Future<void> _syncToFirestoreIfLoggedIn() async {
    final uid = _authRepository.currentUser?.uid;
    if (uid == null) return;
    await _userRepository.updateLanguage(
      uid: uid,
      languageCode: _selectedLanguageCode,
    );
  }
}
