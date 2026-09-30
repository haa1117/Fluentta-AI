import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/ads/ad_placement.dart';
import 'package:fluentta_ai/core/ads/admob_service.dart';
import 'package:fluentta_ai/core/analytics/analytics_events.dart';
import 'package:fluentta_ai/core/analytics/analytics_params.dart';
import 'package:fluentta_ai/core/analytics/analytics_service.dart';
import 'package:fluentta_ai/core/daily_goal/daily_goal_rewards.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

/// A learner blocked by the Out-of-Hearts modal, remembered for one session
/// so a later successful retry of the *same* action can be recognized as a
/// recovery once they've gone Premium.
class _PendingHeartGateRecovery {
  const _PendingHeartGateRecovery({
    required this.featureContext,
    required this.blockedAction,
    required this.sourceScreen,
    required this.recoveryJourneyId,
  });

  final String featureContext;
  final String blockedAction;
  final String sourceScreen;
  final String recoveryJourneyId;
}

enum HeartRefillResult {
  granted,
  adUnavailable,
  dailyCapReached,
  notNeeded,
}

enum XpBoostResult {
  granted,
  adUnavailable,
  dailyCapReached,
}

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    this._localStorage,
    this._progressSyncService,
    this._entitlementsService,
  ) {
    _bootstrap();
    _progressSyncService.addMergeListener(refresh);
  }

  final LocalStorage _localStorage;
  final ProgressSyncService _progressSyncService;
  final EntitlementsService _entitlementsService;

  int _dailyProgressMinutes = 0;
  int _streakDays = 1;
  int _lives = 5;
  int _xpEarned = 0;
  double _lessonProgress = 0;

  int get dailyProgressMinutes => _dailyProgressMinutes;
  int get dailyGoalMinutes => _localStorage.dailyGoalMinutes ?? 10;
  int get streakDays => _streakDays;
  int get lives => _lives;
  int get xpEarned => _xpEarned;
  double get lessonProgress => _lessonProgress;
  bool get isPro => _entitlementsService.isPro;
  bool get hasUnlimitedHearts => _entitlementsService.hasUnlimitedHearts;
  int get dailyHeartAllowance => _entitlementsService.dailyHeartAllowance;
  int get streakFreezesRemaining => _entitlementsService.streakFreezesRemaining;

  double get dailyGoalPercent {
    if (dailyGoalMinutes <= 0) return 0;
    return (_dailyProgressMinutes / dailyGoalMinutes).clamp(0.0, 1.0);
  }

  int get dailyGoalPercentLabel => (dailyGoalPercent * 100).round();

  String get lessonTitle {
    return switch (_localStorage.englishGoal) {
      'travel' => 'Travel English Basics',
      'work' => 'Workplace English Basics',
      'exam' => 'Exam English Basics',
      'everyday' => 'Everyday English Basics',
      _ => 'Workplace English Basics',
    };
  }

  Future<void> _bootstrap() async {
    // Hearts: show last local value immediately. Firestore overwrite + daily
    // refill run in pullAndMerge (merge listener calls [refresh]).
    await _entitlementsService.ensureDailyGoalState();
    _loadFromStorage();
    notifyListeners();
  }

  void _loadFromStorage() {
    _dailyProgressMinutes = _localStorage.dailyProgressMinutes;
    _streakDays = _localStorage.streakDays;
    _lives = _localStorage.lives;
    _xpEarned = _localStorage.xpEarned;
    _lessonProgress = _localStorage.lessonProgress;
  }

  /// Credits actual time spent chatting (rounded to whole minutes) toward
  /// the daily goal — replaces a flat per-session credit, which inflated
  /// the total every time the chat screen was reopened regardless of how
  /// long the learner was actually away.
  Future<void> recordChatMinutes(int minutes) async {
    if (minutes <= 0) return;
    await _progressSyncService.recordDailyGoalProgress(minutes);
    _loadFromStorage();
    notifyListeners();
  }

  Future<bool> useHeart() async {
    final consumed = await _entitlementsService.consumeHeart();
    if (!consumed) return false;
    _loadFromStorage();
    await _progressSyncService.onLivesChanged(_lives);
    notifyListeners();
    return true;
  }

  Future<void> addHearts(int count) async {
    if (_entitlementsService.hasUnlimitedHearts) return;
    await _localStorage.saveLives(_lives + count);
    _loadFromStorage();
    await _progressSyncService.onLivesChanged(_lives);
    notifyListeners();
  }

  // --- Rewarded heart refill (PRD 4.2.13) ---

  int get heartRefillAdsRemaining =>
      _entitlementsService.heartRefillAdsRemainingToday();

  bool get canWatchHeartRefillAd => _entitlementsService.canWatchHeartRefillAd;

  int get rewardedHeartRefillAmount =>
      _entitlementsService.rewardedHeartRefillAmount;

  /// Shows a real rewarded ad and only grants hearts if the user earns the
  /// reward. Returns the outcome so the UI can message it.
  Future<HeartRefillResult> watchAdForHearts() async {
    if (_entitlementsService.hasUnlimitedHearts) {
      return HeartRefillResult.notNeeded;
    }
    if (!_entitlementsService.canWatchHeartRefillAd) {
      return HeartRefillResult.dailyCapReached;
    }

    var earned = false;
    final shown = await AdMobService.instance.showRewarded(
      AdPlacement.rewardedHeartRefill,
      onReward: () => earned = true,
    );

    if (!shown || !earned) return HeartRefillResult.adUnavailable;

    await _entitlementsService.recordHeartRefillAdWatched();
    await addHearts(_entitlementsService.rewardedHeartRefillAmount);
    await _progressSyncService.syncStatsToFirestore();
    return HeartRefillResult.granted;
  }

  // --- Rewarded XP boost (Profile "What's unlocked" popup) ---

  int get xpBoostAdsRemaining => _entitlementsService.xpBoostAdsRemainingToday();
  bool get canWatchXpBoostAd => _entitlementsService.canWatchXpBoostAd;
  static const int rewardedXpBoostAmount = LessonXpRewards.rewardedBoost;

  /// Shows a real rewarded ad and only grants XP if the user earns the
  /// reward. Not tied to any specific lesson — repeatable up to the daily cap.
  Future<XpBoostResult> watchAdForXp() async {
    if (!_entitlementsService.canWatchXpBoostAd) {
      return XpBoostResult.dailyCapReached;
    }

    var earned = false;
    final shown = await AdMobService.instance.showRewarded(
      AdPlacement.rewardedXpBoost,
      onReward: () => earned = true,
    );

    if (!shown || !earned) return XpBoostResult.adUnavailable;

    await _entitlementsService.recordXpBoostAdWatched();
    await _localStorage.addXp(rewardedXpBoostAmount);
    await _progressSyncService.syncStatsToFirestore();
    _loadFromStorage();
    notifyListeners();
    return XpBoostResult.granted;
  }

  Future<void> recordLearningActivity() async {
    await _progressSyncService.recordDailyGoalProgress(
      DailyGoalRewards.coreLesson,
    );
    _loadFromStorage();
    notifyListeners();
  }

  Future<bool> repairStreak() async {
    final repaired = await _entitlementsService.repairStreak();
    if (repaired) {
      _loadFromStorage();
      notifyListeners();
    }
    return repaired;
  }

  Future<void> resumeLesson(VoidCallback onNavigateToLearn) async {
    await _localStorage.saveLessonProgress(
      (_lessonProgress + 0.1).clamp(0.0, 1.0),
    );
    await _entitlementsService.recordLearningActivity();
    _loadFromStorage();
    notifyListeners();
    onNavigateToLearn();
  }

  void refresh() {
    _loadFromStorage();
    notifyListeners();
  }

  // --- Out-of-Hearts recovery tracking (analytics only) -------------------

  _PendingHeartGateRecovery? _pendingHeartGateRecovery;

  /// Records that the learner was just blocked by the Out-of-Hearts modal,
  /// so a later successful retry of the same action can fire
  /// `heart_gated_action_resumed`. A simple per-session field on this
  /// view model — there's no existing "pending recovery" state to hook into,
  /// and a full persistent journey tracker is out of scope for this pass.
  void recordHeartGateBlocked({
    required String featureContext,
    required String blockedAction,
    required String sourceScreen,
    required String recoveryJourneyId,
  }) {
    _pendingHeartGateRecovery = _PendingHeartGateRecovery(
      featureContext: featureContext,
      blockedAction: blockedAction,
      sourceScreen: sourceScreen,
      recoveryJourneyId: recoveryJourneyId,
    );
  }

  /// Call right after a heart-gated action succeeds. Fires
  /// `heart_gated_action_resumed` only if this exact feature/action was
  /// blocked earlier in this session and the learner now has unlimited
  /// hearts (i.e. went Premium in between).
  ///
  /// Simplification: `recovery_method` can't be told apart (fresh purchase
  /// vs. restore) from here — that state lives in the paywall/IAP flow,
  /// which is outside this instrumentation pass's scope — so it always
  /// reports 'premium_purchase'.
  void maybeLogHeartGateRecovery({
    required String featureContext,
    required String blockedAction,
  }) {
    final pending = _pendingHeartGateRecovery;
    if (pending == null) return;
    if (pending.featureContext != featureContext ||
        pending.blockedAction != blockedAction) {
      return;
    }
    if (!hasUnlimitedHearts) return;
    _pendingHeartGateRecovery = null;
    AnalyticsService.instance.log(AnalyticsEvents.heartGatedActionResumed, {
      AnalyticsParams.sourceScreen: pending.sourceScreen,
      AnalyticsParams.featureContext: featureContext,
      AnalyticsParams.blockedAction: blockedAction,
      AnalyticsParams.recoveryMethod: 'premium_purchase',
      AnalyticsParams.recoveryJourneyId: pending.recoveryJourneyId,
    });
  }

  @override
  void dispose() {
    _progressSyncService.removeMergeListener(refresh);
    super.dispose();
  }
}
