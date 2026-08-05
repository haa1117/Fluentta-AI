import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static LocalStorage? _instance;
  static SharedPreferences? _prefs;

  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _selectedLanguageKey = 'selected_language';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userUidKey = 'user_uid';
  static const String _userEmailKey = 'user_email';
  static const String _userDisplayNameKey = 'user_display_name';
  static const String _pendingResetEmailKey = 'pending_reset_email';
  static const String _pendingResetOobCodeKey = 'pending_reset_oob_code';

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

  bool get hasSelectedLanguage => selectedLanguage != null;

  Future<void> setSelectedLanguage(String languageCode) async {
    await _prefs!.setString(_selectedLanguageKey, languageCode);
  }

  bool get isLoggedIn => _prefs!.getBool(_isLoggedInKey) ?? false;

  String? get userUid => _prefs!.getString(_userUidKey);
  String? get userEmail => _prefs!.getString(_userEmailKey);
  String? get userDisplayName => _prefs!.getString(_userDisplayNameKey);

  String? get pendingResetEmail => _prefs!.getString(_pendingResetEmailKey);
  String? get pendingResetOobCode =>
      _prefs!.getString(_pendingResetOobCodeKey);

  Future<void> saveUserSession({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    await _prefs!.setBool(_isLoggedInKey, true);
    await _prefs!.setString(_userUidKey, uid);
    await _prefs!.setString(_userEmailKey, email);
    await _prefs!.setString(_userDisplayNameKey, displayName);
  }

  Future<void> clearUserSession() async {
    await _prefs!.setBool(_isLoggedInKey, false);
    await _prefs!.remove(_userUidKey);
    await _prefs!.remove(_userEmailKey);
    await _prefs!.remove(_userDisplayNameKey);
  }

  Future<void> setPendingResetEmail(String email) async {
    await _prefs!.setString(_pendingResetEmailKey, email);
  }

  Future<void> setPendingResetOobCode(String code) async {
    await _prefs!.setString(_pendingResetOobCodeKey, code);
  }

  Future<void> clearPendingReset() async {
    await _prefs!.remove(_pendingResetEmailKey);
    await _prefs!.remove(_pendingResetOobCodeKey);
  }

  bool get shouldShowOnboarding => !isOnboardingComplete;
  bool get shouldShowLanguage => isOnboardingComplete && !hasSelectedLanguage;
  bool get shouldShowSignIn =>
      isOnboardingComplete && hasSelectedLanguage && !isLoggedIn;
}
