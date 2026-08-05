import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/language_model.dart';

class LanguageViewModel extends ChangeNotifier {
  LanguageViewModel(this._localStorage);

  final LocalStorage _localStorage;

  static const List<LanguageModel> suggestedLanguages = [
    LanguageModel(
      code: 'ur',
      name: 'Urdu',
      flagEmoji: '🇵🇰',
      subtitle: 'Recommended based on your region',
      isSuggested: true,
    ),
  ];

  static const List<LanguageModel> otherLanguages = [
    LanguageModel(
      code: 'en',
      name: 'English',
      flagEmoji: '🇺🇸',
    ),
    LanguageModel(
      code: 'es',
      name: 'Spanish',
      flagEmoji: '🇪🇸',
    ),
  ];

  String _selectedLanguageCode = 'ur';
  String get selectedLanguageCode => _selectedLanguageCode;

  void selectLanguage(String code) {
    _selectedLanguageCode = code;
    notifyListeners();
  }

  Future<void> continueWithLanguage(VoidCallback onComplete) async {
    await _localStorage.setSelectedLanguage(_selectedLanguageCode);
    await _localStorage.setFirstLaunchComplete();
    onComplete();
  }
}
