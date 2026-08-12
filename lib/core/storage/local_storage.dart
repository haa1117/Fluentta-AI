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
  static const String _setupCompleteKey = 'setup_complete';
  static const String _englishGoalKey = 'english_goal';
  static const String _englishLevelKey = 'english_level';
  static const String _dailyGoalMinutesKey = 'daily_goal_minutes';
  static const String _dailyProgressMinutesKey = 'daily_progress_minutes';
  static const String _streakDaysKey = 'streak_days';
  static const String _livesKey = 'lives';
  static const String _lessonProgressKey = 'lesson_progress';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _dailyReminderEnabledKey = 'daily_reminder_enabled';
  static const String _reminderHourKey = 'reminder_hour';
  static const String _reminderMinuteKey = 'reminder_minute';
  static const String _xpEarnedKey = 'xp_earned';
  static const String _wordsLearnedCountKey = 'words_learned_count';
  static const String _lessonsCompletedCountKey = 'lessons_completed_count';
  static const String _correctionsCountKey = 'corrections_count';

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

  bool get isSetupComplete => _prefs!.getBool(_setupCompleteKey) ?? false;
  String? get englishGoal => _prefs!.getString(_englishGoalKey);
  String? get englishLevel => _prefs!.getString(_englishLevelKey);
  int? get dailyGoalMinutes => _prefs!.getInt(_dailyGoalMinutesKey);
  int get dailyProgressMinutes => _prefs!.getInt(_dailyProgressMinutesKey) ?? 6;
  int get streakDays => _prefs!.getInt(_streakDaysKey) ?? 1;
  int get lives => _prefs!.getInt(_livesKey) ?? 5;
  double get lessonProgress => _prefs!.getDouble(_lessonProgressKey) ?? 0.35;
  bool get notificationsEnabled =>
      _prefs!.getBool(_notificationsEnabledKey) ?? true;
  bool get dailyReminderEnabled =>
      _prefs!.getBool(_dailyReminderEnabledKey) ?? true;
  int get reminderHour => _prefs!.getInt(_reminderHourKey) ?? 20;
  int get reminderMinute => _prefs!.getInt(_reminderMinuteKey) ?? 0;
  int get xpEarned => _prefs!.getInt(_xpEarnedKey) ?? 320;
  int get wordsLearnedCount => _prefs!.getInt(_wordsLearnedCountKey) ?? 24;
  int get lessonsCompletedCount =>
      _prefs!.getInt(_lessonsCompletedCountKey) ?? 8;
  int get correctionsCount => _prefs!.getInt(_correctionsCountKey) ?? 12;

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
    await clearSetupPreferences();
    await resetHomeProgress();
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

  Future<void> saveSetupPreferences({
    required String englishGoal,
    required String englishLevel,
    required int dailyGoalMinutes,
  }) async {
    await _prefs!.setString(_englishGoalKey, englishGoal);
    await _prefs!.setString(_englishLevelKey, englishLevel);
    await _prefs!.setInt(_dailyGoalMinutesKey, dailyGoalMinutes);
  }

  Future<void> setSetupComplete() async {
    await _prefs!.setBool(_setupCompleteKey, true);
  }

  Future<void> clearSetupPreferences() async {
    await _prefs!.remove(_setupCompleteKey);
    await _prefs!.remove(_englishGoalKey);
    await _prefs!.remove(_englishLevelKey);
    await _prefs!.remove(_dailyGoalMinutesKey);
  }

  Future<void> saveDailyProgressMinutes(int minutes) async {
    await _prefs!.setInt(_dailyProgressMinutesKey, minutes);
  }

  Future<void> saveLessonProgress(double progress) async {
    await _prefs!.setDouble(_lessonProgressKey, progress.clamp(0, 1));
  }

  Future<void> incrementDailyProgress(int minutes) async {
    final current = dailyProgressMinutes + minutes;
    final goal = dailyGoalMinutes ?? 10;
    await saveDailyProgressMinutes(current > goal ? goal : current);
  }

  Future<void> saveLives(int lives) async {
    await _prefs!.setInt(_livesKey, lives.clamp(0, 99));
  }

  Future<void> resetHomeProgress() async {
    await _prefs!.remove(_dailyProgressMinutesKey);
    await _prefs!.remove(_streakDaysKey);
    await _prefs!.remove(_livesKey);
    await _prefs!.remove(_lessonProgressKey);
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs!.setBool(_notificationsEnabledKey, value);
  }

  Future<void> setDailyReminderEnabled(bool value) async {
    await _prefs!.setBool(_dailyReminderEnabledKey, value);
  }

  Future<void> setReminderTime({required int hour, required int minute}) async {
    await _prefs!.setInt(_reminderHourKey, hour);
    await _prefs!.setInt(_reminderMinuteKey, minute);
  }

  bool get shouldShowOnboarding => !isOnboardingComplete;
  bool get shouldShowLanguage => isOnboardingComplete && !hasSelectedLanguage;
  bool get shouldShowSignIn =>
      isOnboardingComplete && hasSelectedLanguage && !isLoggedIn;
}
