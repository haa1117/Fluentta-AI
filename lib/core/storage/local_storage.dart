import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static LocalStorage? _instance;
  static SharedPreferences? _prefs;

  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _selectedLanguageKey = 'selected_language';
  static const String _isFirstLaunchKey = 'is_first_launch';

  static Future<LocalStorage> getInstance() async {
    _instance ??= LocalStorage._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static LocalStorage get instance {
    if (_instance == null || _prefs == null) {
      throw Exception(
        'LocalStorage not initialized. Call LocalStorage.getInstance() first.',
      );
    }
    return _instance!;
  }

  bool get isOnboardingComplete =>
      _prefs!.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete() async {
    await _prefs!.setBool(_onboardingCompleteKey, true);
  }

  String? get selectedLanguage => _prefs!.getString(_selectedLanguageKey);

  Future<void> setSelectedLanguage(String languageCode) async {
    await _prefs!.setString(_selectedLanguageKey, languageCode);
  }

  bool get isFirstLaunch => _prefs!.getBool(_isFirstLaunchKey) ?? true;

  Future<void> setFirstLaunchComplete() async {
    await _prefs!.setBool(_isFirstLaunchKey, false);
  }
}
