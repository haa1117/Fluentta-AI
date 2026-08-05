import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/language_model.dart';
import 'package:fluentta_ai/data/repositories/auth_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';

class LanguageViewModel extends ChangeNotifier {
  LanguageViewModel(
    this._localStorage,
    this._userRepository,
    this._authRepository,
  );

  final LocalStorage _localStorage;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

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
