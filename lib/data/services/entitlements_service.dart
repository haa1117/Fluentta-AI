import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/entitlements/user_entitlements.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';

/// Applies free vs pro rules for hearts, streaks, and feature access.
class EntitlementsService {
  EntitlementsService(this._localStorage);

  final LocalStorage _localStorage;

  bool get isPro => UserEntitlements.isPro(_localStorage.isPremium);

  bool get hasUnlimitedHearts =>
      UserEntitlements.hasUnlimitedHearts(_localStorage.isPremium);

  int get dailyHeartAllowance => UserEntitlements.freeDailyHearts;

  int get streakFreezesRemaining {
    final allowance = UserEntitlements.streakFreezesAllowance(isPro);
    return (allowance - _currentWeekFreezesUsed()).clamp(0, 999);
  }

  bool get canRepairStreakThisMonth {
    if (!UserEntitlements.canRepairStreak(isPro)) return false;
    final monthKey = _yearMonth(DateTime.now());
    return _localStorage.streakRepairMonthUsed != monthKey;
  }

  bool canAccessRoleplayScenario(String scenarioId) =>
      UserEntitlements.canAccessRoleplayScenario(
        scenarioId,
        _localStorage.isPremium,
      );

  bool canAccessCefrLevel(CefrLevel level) =>
      UserEntitlements.canAccessCefrLevel(level, _localStorage.isPremium);

  CefrLevel contentLevelForUser() => UserEntitlements.contentLevelForUser(
        _localStorage.englishLevel,
        _localStorage.isPremium,
      );

  bool canUseOfflineMode() =>
      UserEntitlements.canUseOfflineMode(_localStorage.isPremium);

  bool canViewWeeklyProgressReport() =>
      UserEntitlements.canViewWeeklyProgressReport(_localStorage.isPremium);

  String todayIso() => _isoDate(DateTime.now());

  /// Resets daily minutes at midnight and reconciles streak if days were missed.
  Future<void> ensureDailyGoalState() async {
    await ensureDailyProgressReset();
    await _reconcileStreakOnOpen();
  }

  /// Clears today's progress counter when the calendar day changes.
  Future<void> ensureDailyProgressReset() async {
    final today = todayIso();
    final lastDate = _localStorage.lastDailyProgressDate;
    if (lastDate == today) return;

    await _localStorage.saveDailyProgressMinutes(0);
    await _localStorage.setLastDailyProgressDate(today);
  }

  /// Adds minutes toward the daily goal and updates the learning streak.
  Future<void> recordDailyGoalProgress(int minutes) async {
    if (minutes <= 0) return;

    await ensureDailyProgressReset();
    await _localStorage.incrementDailyProgress(minutes);
    await recordLearningActivity();
  }

  /// Refills free users to the daily heart allowance once per calendar day.
  Future<void> ensureDailyHeartsReset() async {
    if (hasUnlimitedHearts) return;

    final today = todayIso();
    if (_localStorage.lastHeartResetDate == today) return;

    await _localStorage.setLastHeartResetDate(today);
    await _localStorage.saveLives(dailyHeartAllowance);
  }

  Future<bool> consumeHeart() async {
    await ensureDailyHeartsReset();
    if (hasUnlimitedHearts) return true;
    if (_localStorage.lives <= 0) return false;
    await _localStorage.saveLives(_localStorage.lives - 1);
    return true;
  }

  Future<void> recordLearningActivity() async {
    await _resetStreakFreezeWeekIfNeeded();
    final today = DateTime.now();
    final todayIso = _isoDate(today);
    final lastActive = _localStorage.lastStreakActiveDate;

    if (lastActive == todayIso) return;

    final currentStreak = _localStorage.streakDays;

    if (lastActive == null || lastActive.isEmpty) {
      await _localStorage.setStreakDays(currentStreak <= 0 ? 1 : currentStreak);
      await _localStorage.setLastStreakActiveDate(todayIso);
      return;
    }

    final lastDate = DateTime.parse(lastActive);
    final dayGap = today.difference(_dateOnly(lastDate)).inDays;

    if (dayGap == 1) {
      await _localStorage.setStreakDays(currentStreak + 1);
    } else if (dayGap > 1) {
      final preserved = await _tryAutoStreakFreeze(dayGap - 1);
      if (preserved) {
        await _localStorage.setStreakDays(currentStreak + 1);
      } else {
        if (currentStreak > 0) {
          await _localStorage.setStreakBeforeBreak(currentStreak);
        }
        await _localStorage.setStreakDays(1);
      }
    }

    await _localStorage.setLastStreakActiveDate(todayIso);
  }

  Future<void> _reconcileStreakOnOpen() async {
    await _resetStreakFreezeWeekIfNeeded();

    final today = DateTime.now();
    final todayIso = _isoDate(today);
    final lastActive = _localStorage.lastStreakActiveDate;

    if (lastActive == null || lastActive.isEmpty) return;
    if (lastActive == todayIso) return;

    final lastDate = DateTime.parse(lastActive);
    final dayGap = today.difference(_dateOnly(lastDate)).inDays;

    if (dayGap <= 1) return;

    final preserved = await _tryAutoStreakFreeze(dayGap - 1);
    if (preserved) return;

    if (_localStorage.streakDays > 0) {
      await _localStorage.setStreakBeforeBreak(_localStorage.streakDays);
    }
    await _localStorage.setStreakDays(0);
  }

  Future<bool> useStreakFreeze() async {
    await _resetStreakFreezeWeekIfNeeded();
    if (streakFreezesRemaining <= 0) return false;
    await _localStorage.setStreakFreezesUsedThisWeek(
      _localStorage.streakFreezesUsedThisWeek + 1,
    );
    return true;
  }

  Future<bool> repairStreak() async {
    if (!canRepairStreakThisMonth) return false;
    final restored = _localStorage.streakBeforeBreak;
    if (restored <= 0) return false;

    await _localStorage.setStreakDays(restored);
    await _localStorage.setStreakRepairMonthUsed(_yearMonth(DateTime.now()));
    await _localStorage.setLastStreakActiveDate(todayIso());
    return true;
  }

  Future<bool> _tryAutoStreakFreeze(int missedDays) async {
    if (missedDays <= 0) return true;
    await _resetStreakFreezeWeekIfNeeded();
    if (streakFreezesRemaining < missedDays) return false;

    await _localStorage.setStreakFreezesUsedThisWeek(
      _localStorage.streakFreezesUsedThisWeek + missedDays,
    );
    return true;
  }

  int _currentWeekFreezesUsed() {
    final weekStart = _isoDate(_weekStart(DateTime.now()));
    if (_localStorage.streakFreezeWeekStart != weekStart) return 0;
    return _localStorage.streakFreezesUsedThisWeek;
  }

  Future<void> _resetStreakFreezeWeekIfNeeded() async {
    final weekStart = _isoDate(_weekStart(DateTime.now()));
    final stored = _localStorage.streakFreezeWeekStart;
    if (stored != weekStart) {
      await _localStorage.setStreakFreezeWeekStart(weekStart);
      await _localStorage.setStreakFreezesUsedThisWeek(0);
    }
  }

  String _isoDate(DateTime date) {
    final d = _dateOnly(date);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  String _yearMonth(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _weekStart(DateTime date) {
    final d = _dateOnly(date);
    return d.subtract(Duration(days: d.weekday - DateTime.monday));
  }
}
