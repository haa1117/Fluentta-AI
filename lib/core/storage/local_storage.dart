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
  static const String _isPremiumKey = 'is_premium';
  static const String _premiumProductIdKey = 'premium_product_id';
  static const String _lastHeartResetDateKey = 'last_heart_reset_date';
  static const String _lastStreakActiveDateKey = 'last_streak_active_date';
  static const String _streakFreezeWeekStartKey = 'streak_freeze_week_start';
  static const String _streakFreezesUsedWeekKey = 'streak_freezes_used_week';
  static const String _streakRepairMonthKey = 'streak_repair_month_used';
  static const String _streakBeforeBreakKey = 'streak_before_break';
  static const String _roleplayLessonBonusKey = 'roleplay_lesson_bonus_v1';
  static const String _xpBoostClaimedKey = 'xp_boost_claimed_v1';
  static const String _lessonXpAwardedKey = 'lesson_xp_awarded_v1';
  static const String _lessonXpGrantedKey = 'lesson_xp_granted_v1';
  static const String _xpAwardedBackfillDoneKey = 'xp_awarded_backfill_done';
  static const String _lessonXpGrantMigrationV2Key = 'lesson_xp_grant_migration_v2';

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

  /// True when setup was finished, including legacy users who saved prefs
  /// before the completion flag existed.
  bool get hasCompletedSetup =>
      isSetupComplete ||
      (englishGoal != null &&
          englishLevel != null &&
          dailyGoalMinutes != null);

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
  int get xpEarned => _prefs!.getInt(_xpEarnedKey) ?? 0;
  int get wordsLearnedCount => _prefs!.getInt(_wordsLearnedCountKey) ?? 0;
  int get lessonsCompletedCount =>
      _prefs!.getInt(_lessonsCompletedCountKey) ?? 0;
  int get correctionsCount => _prefs!.getInt(_correctionsCountKey) ?? 0;
  bool get isPremium => _prefs!.getBool(_isPremiumKey) ?? false;
  String? get premiumProductId => _prefs!.getString(_premiumProductIdKey);
  String? get lastHeartResetDate => _prefs!.getString(_lastHeartResetDateKey);
  String? get lastStreakActiveDate =>
      _prefs!.getString(_lastStreakActiveDateKey);
  String? get streakFreezeWeekStart =>
      _prefs!.getString(_streakFreezeWeekStartKey);
  int get streakFreezesUsedThisWeek =>
      _prefs!.getInt(_streakFreezesUsedWeekKey) ?? 0;
  String? get streakRepairMonthUsed =>
      _prefs!.getString(_streakRepairMonthKey);
  int get streakBeforeBreak => _prefs!.getInt(_streakBeforeBreakKey) ?? 0;

  String? getString(String key) => _prefs!.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs!.setString(key, value);
  }

  Future<void> incrementLessonsCompleted() async {
    await _prefs!.setInt(
      _lessonsCompletedCountKey,
      lessonsCompletedCount + 1,
    );
  }

  Future<void> incrementWordsLearned(int count) async {
    if (count <= 0) return;
    await _prefs!.setInt(
      _wordsLearnedCountKey,
      wordsLearnedCount + count,
    );
  }

  Future<void> incrementCorrectionsCount(int count) async {
    if (count <= 0) return;
    await _prefs!.setInt(
      _correctionsCountKey,
      correctionsCount + count,
    );
  }

  Future<void> setPremiumActive({
    required bool active,
    String? productId,
  }) async {
    await _prefs!.setBool(_isPremiumKey, active);
    if (active && productId != null) {
      await _prefs!.setString(_premiumProductIdKey, productId);
    } else if (!active) {
      await _prefs!.remove(_premiumProductIdKey);
    }
  }

  Future<void> addXp(int amount) async {
    await _prefs!.setInt(_xpEarnedKey, xpEarned + amount);
  }

  Future<void> saveStats({
    int? xpEarned,
    int? wordsLearnedCount,
    int? lessonsCompletedCount,
    int? correctionsCount,
  }) async {
    if (xpEarned != null) {
      await _prefs!.setInt(_xpEarnedKey, xpEarned);
    }
    if (wordsLearnedCount != null) {
      await _prefs!.setInt(_wordsLearnedCountKey, wordsLearnedCount);
    }
    if (lessonsCompletedCount != null) {
      await _prefs!.setInt(_lessonsCompletedCountKey, lessonsCompletedCount);
    }
    if (correctionsCount != null) {
      await _prefs!.setInt(_correctionsCountKey, correctionsCount);
    }
  }

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
    await _clearUserLearningData();
  }

  /// Clears locally cached learning data (Firestore remains the source of truth).
  Future<void> _clearUserLearningData() async {
    await clearSetupPreferences();
    await resetHomeProgress();
    await clearPremiumStatus();

    await _prefs!.remove(_xpEarnedKey);
    await _prefs!.remove(_wordsLearnedCountKey);
    await _prefs!.remove(_lessonsCompletedCountKey);
    await _prefs!.remove(_correctionsCountKey);
    await _prefs!.remove(_lastHeartResetDateKey);
    await _prefs!.remove(_lastStreakActiveDateKey);
    await _prefs!.remove(_streakFreezeWeekStartKey);
    await _prefs!.remove(_streakFreezesUsedWeekKey);
    await _prefs!.remove(_streakRepairMonthKey);
    await _prefs!.remove(_streakBeforeBreakKey);
    await _prefs!.remove(_roleplayLessonBonusKey);
    await _prefs!.remove(_xpBoostClaimedKey);
    await _prefs!.remove(_lessonXpAwardedKey);
    await _prefs!.remove(_lessonXpGrantedKey);
    await _prefs!.remove(_xpAwardedBackfillDoneKey);
    await _prefs!.remove(_lessonXpGrantMigrationV2Key);

    const repositoryKeys = [
      'lesson_progress_v1',
      'srs_words_v1',
      'english_basics_step_v1',
      'saved_words_v1',
      'daily_lesson_v1',
      'daily_vocab_v1',
      'roleplay_content_cache_v1',
    ];
    for (final key in repositoryKeys) {
      await _prefs!.remove(key);
    }
  }

  Future<void> setPendingResetEmail(String email) async {
    await _prefs!.setString(_pendingResetEmailKey, email);
  }

  Future<void> setPendingResetOobCode(String code) async {
    await _prefs!.setString(_pendingResetOobCodeKey, code);
  }

  Future<void> clearPendingResetOobCode() async {
    await _prefs!.remove(_pendingResetOobCodeKey);
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

  Future<void> setLastHeartResetDate(String isoDate) async {
    await _prefs!.setString(_lastHeartResetDateKey, isoDate);
  }

  Future<void> setStreakDays(int days) async {
    await _prefs!.setInt(_streakDaysKey, days.clamp(0, 9999));
  }

  Future<void> setLastStreakActiveDate(String isoDate) async {
    await _prefs!.setString(_lastStreakActiveDateKey, isoDate);
  }

  Future<void> setStreakFreezeWeekStart(String isoDate) async {
    await _prefs!.setString(_streakFreezeWeekStartKey, isoDate);
  }

  Future<void> setStreakFreezesUsedThisWeek(int count) async {
    await _prefs!.setInt(_streakFreezesUsedWeekKey, count.clamp(0, 99));
  }

  Future<void> setStreakRepairMonthUsed(String yearMonth) async {
    await _prefs!.setString(_streakRepairMonthKey, yearMonth);
  }

  Future<void> setStreakBeforeBreak(int days) async {
    await _prefs!.setInt(_streakBeforeBreakKey, days.clamp(0, 9999));
  }

  Future<void> resetHomeProgress() async {
    await _prefs!.remove(_dailyProgressMinutesKey);
    await _prefs!.remove(_streakDaysKey);
    await _prefs!.remove(_livesKey);
    await _prefs!.remove(_lessonProgressKey);
  }

  Future<void> clearPremiumStatus() async {
    await _prefs!.remove(_isPremiumKey);
    await _prefs!.remove(_premiumProductIdKey);
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

  Future<bool> hasRoleplayLessonBonus(String bonusKey) async {
    final raw = _prefs!.getString(_roleplayLessonBonusKey);
    if (raw == null || raw.isEmpty) return false;
    final keys = raw.split('\n');
    return keys.contains(bonusKey);
  }

  Future<void> markRoleplayLessonBonus(String bonusKey) async {
    if (await hasRoleplayLessonBonus(bonusKey)) return;
    final raw = _prefs!.getString(_roleplayLessonBonusKey);
    final keys = raw == null || raw.isEmpty
        ? <String>[]
        : raw.split('\n').where((k) => k.isNotEmpty).toList();
    keys.add(bonusKey);
    await _prefs!.setString(_roleplayLessonBonusKey, keys.join('\n'));
  }

  Future<bool> hasXpBoostClaimed(String lessonKey) async {
    final raw = _prefs!.getString(_xpBoostClaimedKey);
    if (raw == null || raw.isEmpty) return false;
    return raw.split('\n').contains(lessonKey);
  }

  Future<void> markXpBoostClaimed(String lessonKey) async {
    if (await hasXpBoostClaimed(lessonKey)) return;
    final raw = _prefs!.getString(_xpBoostClaimedKey);
    final keys = raw == null || raw.isEmpty
        ? <String>[]
        : raw.split('\n').where((k) => k.isNotEmpty).toList();
    keys.add(lessonKey);
    await _prefs!.setString(_xpBoostClaimedKey, keys.join('\n'));
  }

  Future<bool> hasLessonXpAwarded(String lessonId) async {
    final raw = _prefs!.getString(_lessonXpAwardedKey);
    if (raw == null || raw.isEmpty) return false;
    return raw.split('\n').contains(lessonId);
  }

  Future<void> markLessonXpAwarded(String lessonId) async {
    if (await hasLessonXpAwarded(lessonId)) return;
    final raw = _prefs!.getString(_lessonXpAwardedKey);
    final keys = raw == null || raw.isEmpty
        ? <String>[]
        : raw.split('\n').where((k) => k.isNotEmpty).toList();
    keys.add(lessonId);
    await _prefs!.setString(_lessonXpAwardedKey, keys.join('\n'));
  }

  Future<bool> hasLessonXpGranted(String lessonId) async {
    final raw = _prefs!.getString(_lessonXpGrantedKey);
    if (raw == null || raw.isEmpty) return false;
    return raw.split('\n').contains(lessonId);
  }

  Future<void> markLessonXpGranted(String lessonId) async {
    if (await hasLessonXpGranted(lessonId)) return;
    final raw = _prefs!.getString(_lessonXpGrantedKey);
    final keys = raw == null || raw.isEmpty
        ? <String>[]
        : raw.split('\n').where((k) => k.isNotEmpty).toList();
    keys.add(lessonId);
    await _prefs!.setString(_lessonXpGrantedKey, keys.join('\n'));
    await markLessonXpAwarded(lessonId);
  }

  bool get lessonXpGrantMigrationV2Done =>
      _prefs!.getBool(_lessonXpGrantMigrationV2Key) ?? false;

  Future<void> setLessonXpGrantMigrationV2Done() async {
    await _prefs!.setBool(_lessonXpGrantMigrationV2Key, true);
  }

  bool get xpAwardedBackfillDone =>
      _prefs!.getBool(_xpAwardedBackfillDoneKey) ?? false;

  Future<void> setXpAwardedBackfillDone() async {
    await _prefs!.setBool(_xpAwardedBackfillDoneKey, true);
  }

  bool get shouldShowOnboarding => !isOnboardingComplete;
  bool get shouldShowLanguage => isOnboardingComplete && !hasSelectedLanguage;
  bool get shouldShowSignIn =>
      isOnboardingComplete && hasSelectedLanguage && !isLoggedIn;
}
