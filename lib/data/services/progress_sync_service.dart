import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fluentta_ai/core/cefr/cefr_level.dart';
import 'package:fluentta_ai/core/daily_goal/daily_goal_rewards.dart';
import 'package:fluentta_ai/core/network/network_status.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_practice_type.dart';
import 'package:fluentta_ai/core/roleplay/roleplay_xp_rewards.dart';
import 'package:fluentta_ai/core/xp/lesson_xp_rewards.dart';
import 'package:fluentta_ai/data/models/learning_lesson_model.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/learning_stats_service.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_sync_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';

class ProgressSyncService {
  ProgressSyncService({
    required ProgressRepository progressRepository,
    required ProgressSyncRepository syncRepository,
    required UserRepository userRepository,
    required LocalStorage localStorage,
    required LearningStatsService learningStatsService,
    required EntitlementsService entitlementsService,
    Connectivity? connectivity,
  })  : _progressRepository = progressRepository,
        _syncRepository = syncRepository,
        _userRepository = userRepository,
        _localStorage = localStorage,
        _learningStatsService = learningStatsService,
        _entitlementsService = entitlementsService,
        _connectivity = connectivity ?? Connectivity();

  final ProgressRepository _progressRepository;
  final ProgressSyncRepository _syncRepository;
  final UserRepository _userRepository;
  final LocalStorage _localStorage;
  final LearningStatsService _learningStatsService;
  final EntitlementsService _entitlementsService;
  final Connectivity _connectivity;

  final List<LessonProgressModel> _pendingWrites = [];
  int? _pendingLivesWrite;
  bool _pendingStatsSync = false;
  bool _pendingDailyGoalSync = false;
  final List<VoidCallback> _mergeListeners = [];

  /// Current cumulative XP — read before/after a completion to detect newly
  /// crossed unlock thresholds (see NewlyUnlockedContent).
  int get totalXp => _localStorage.xpEarned;

  void addMergeListener(VoidCallback listener) {
    _mergeListeners.add(listener);
  }

  void removeMergeListener(VoidCallback listener) {
    _mergeListeners.remove(listener);
  }

  void _notifyMerged() {
    for (final listener in List<VoidCallback>.from(_mergeListeners)) {
      listener();
    }
  }

  Future<bool> get _isOnline async {
    final result = await _connectivity.checkConnectivity();
    return NetworkStatus.hasConnection(result);
  }

  String? get _uid => _localStorage.userUid;

  Future<void> pullAndMerge() async {
    final uid = _uid;
    if (uid == null) return;

    await _progressRepository.initialize();
    if (!await _isOnline) {
      await _reconcileDailyHearts();
      _notifyMerged();
      return;
    }

    final remote = await _syncRepository.fetchAll(uid);
    await _progressRepository.mergeRemoteProgress(remote);
    await _flushPending(uid);
    await _pullLives(uid);
    await _pullStats(uid);
    await _pullDailyGoal(uid);
    await _learningStatsService.reconcileFromProgress();
    await _syncStatsToFirestore(force: true);
    _notifyMerged();
  }

  Future<void> onLivesChanged(int lives) async {
    _pendingLivesWrite = lives;
    await _pushLives(lives);
  }

  Future<void> onProgressChanged(LessonProgressModel progress) async {
    await _progressRepository.saveProgress(progress);
    await _pushProgress(progress);
  }

  Future<void> onLessonCompleted({
    required LessonProgressModel progress,
    int wordsLearned = 0,
  }) async {
    await _applyLocalLessonCompletion(
      progress: progress,
      wordsLearned: wordsLearned,
    );
    unawaited(_flushCompletionToRemote(progress));
  }

  /// PRD 4.2.2 — +50 XP the first time all 10 lessons of a core module
  /// (e.g. A1 vocabulary) are completed.
  Future<void> _maybeAwardCoreModuleBonus(LessonProgressModel progress) async {
    if (!LessonXpRewards.coreTypes.contains(progress.type)) return;
    final level = CefrLevel.fromCode(progress.cefrLevel);
    if (_progressRepository.completedCoreLessonsOfType(level, progress.type) <
        10) {
      return;
    }
    final moduleKey = '${level.code}|${progress.type}';
    if (await _localStorage.hasModuleXpGranted(moduleKey)) return;
    await _localStorage.markModuleXpGranted(moduleKey);
    await _localStorage.addXp(LessonXpRewards.coreModuleComplete);
  }

  /// PRD 4.2.3 — Premium learners get the +5 lesson boost automatically,
  /// without watching an ad. Shares the claimed-set with the rewarded boost
  /// so a free→Premium user can never collect it twice.
  Future<void> _maybeAutoGrantPremiumXpBoost(String lessonId) async {
    if (!_entitlementsService.isPro) return;
    if (await _localStorage.hasXpBoostClaimed(lessonId)) return;
    await _localStorage.markXpBoostClaimed(lessonId);
    await _localStorage.addXp(LessonXpRewards.rewardedBoost);
  }

  Future<void> recordDailyGoalProgress(int minutes) async {
    await _applyLocalDailyGoalProgress(minutes);
    unawaited(_pushDailyGoal());
  }

  Future<void> _applyLocalDailyGoalProgress(int minutes) async {
    await _entitlementsService.recordDailyGoalProgress(minutes);
    _pendingDailyGoalSync = true;
    _notifyMerged();
  }

  /// Disk + XP first; Firestore is flushed by [_flushCompletionToRemote].
  Future<void> _applyLocalLessonCompletion({
    required LessonProgressModel progress,
    int wordsLearned = 0,
  }) async {
    await _progressRepository.saveProgress(progress);

    final xpAmount = LessonXpRewards.forLessonType(progress.type);
    final firstCompletion =
        !await _localStorage.hasLessonXpGranted(progress.lessonId);
    if (firstCompletion) {
      await _localStorage.markLessonXpGranted(progress.lessonId);
      await _localStorage.addXp(xpAmount);
      if (wordsLearned > 0) {
        await _localStorage.incrementWordsLearned(wordsLearned);
      }
      await _applyLocalDailyGoalProgress(
        DailyGoalRewards.forLessonType(progress.type),
      );
      await _maybeAwardCoreModuleBonus(progress);
      await _maybeAutoGrantPremiumXpBoost(progress.lessonId);
      _pendingStatsSync = true;
    }

    await _learningStatsService.reconcileFromProgress();
    _pendingStatsSync = true;
    _notifyMerged();
  }

  Future<void> _flushCompletionToRemote(LessonProgressModel progress) async {
    try {
      await _syncStatsToFirestore(force: true);
      await _pushProgress(progress);
      await _pushDailyGoal();
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('Background lesson sync failed: $e\n$stack');
      }
    }
  }

  /// Awards roleplay module XP once per lesson module; +2 bonus when all three complete.
  /// Returns total XP granted on this call (0 if replay).
  Future<int> onRoleplayModuleCompleted({
    required LessonProgressModel progress,
    required int xpAmount,
    required String scenarioId,
    required int lessonNumber,
    int wordsLearned = 0,
  }) async {
    await _progressRepository.saveProgress(progress);

    var totalGranted = 0;
    final firstCompletion =
        !await _localStorage.hasLessonXpGranted(progress.lessonId);
    if (firstCompletion) {
      await _localStorage.markLessonXpGranted(progress.lessonId);
      totalGranted = xpAmount;
      await _localStorage.addXp(xpAmount);

      if (wordsLearned > 0) {
        await _localStorage.incrementWordsLearned(wordsLearned);
      }
    }

    final bonus = firstCompletion
        ? await _maybeAwardRoleplayLessonBonus(
            scenarioId: scenarioId,
            lessonNumber: lessonNumber,
            cefrLevel: progress.cefrLevel,
          )
        : 0;
    totalGranted += bonus;

    if (firstCompletion) {
      await _applyLocalDailyGoalProgress(DailyGoalRewards.roleplayModule);
      await _maybeAutoGrantPremiumXpBoost(progress.lessonId);
      _pendingStatsSync = true;
    }

    await _learningStatsService.reconcileFromProgress();
    _pendingStatsSync = true;
    _notifyMerged();
    unawaited(_flushCompletionToRemote(progress));
    return totalGranted;
  }

  Future<void> _migrateBackfillLessonXpGrants() async {
    if (_localStorage.lessonXpGrantMigrationV2Done) return;

    await _progressRepository.initialize();

    for (final entry in _progressRepository.allProgress.entries) {
      final progress = entry.value;
      if (progress.status != LearningLessonStatus.completed) continue;

      final lessonId = entry.key;
      if (await _localStorage.hasLessonXpGranted(lessonId)) continue;
      if (!await _localStorage.hasLessonXpAwarded(lessonId)) continue;

      final xpAmount = LessonXpRewards.forLessonType(progress.type);
      await _localStorage.markLessonXpGranted(lessonId);
      await _localStorage.addXp(xpAmount);
    }

    await _localStorage.setLessonXpGrantMigrationV2Done();
    await _learningStatsService.reconcileFromProgress();
    _pendingStatsSync = true;
    await _syncStatsToFirestore(force: true);
    _notifyMerged();
  }

  Future<void> _backfillLessonXpAwardedFlags() async {
    if (_localStorage.xpAwardedBackfillDone) return;

    for (final entry in _progressRepository.allProgress.entries) {
      if (entry.value.status == LearningLessonStatus.completed) {
        await _localStorage.markLessonXpAwarded(entry.key);
      }
    }
    await _localStorage.setXpAwardedBackfillDone();
  }

  Future<int> _maybeAwardRoleplayLessonBonus({
    required String scenarioId,
    required int lessonNumber,
    required String cefrLevel,
  }) async {
    final suffix = lessonNumber.toString().padLeft(2, '0');
    final vocabId = '${scenarioId}_vocab_$suffix';
    final quickId = '${scenarioId}_quick_$suffix';
    final dialogueId = '${scenarioId}_dialogue_$suffix';

    await _progressRepository.initialize();
    final all = _progressRepository.allProgress;

    bool moduleDone(String lessonId, String typeId) {
      final entry = all[lessonId];
      return entry != null &&
          entry.type == typeId &&
          entry.status == LearningLessonStatus.completed;
    }

    if (!moduleDone(vocabId, RoleplayPracticeType.vocabulary.id)) return 0;
    if (!moduleDone(quickId, RoleplayPracticeType.quickCheck.id)) return 0;
    if (!moduleDone(dialogueId, RoleplayPracticeType.dialogue.id)) return 0;

    final bonusKey = '$scenarioId|$cefrLevel|$lessonNumber';
    if (await _localStorage.hasRoleplayLessonBonus(bonusKey)) return 0;

    await _localStorage.markRoleplayLessonBonus(bonusKey);
    await _localStorage.addXp(RoleplayXpRewards.lessonCompleteBonus);
    return RoleplayXpRewards.lessonCompleteBonus;
  }

  Future<void> _pushProgress(LessonProgressModel progress) async {
    final uid = _uid;
    if (uid == null) {
      _pendingWrites.add(progress);
      return;
    }
    if (!await _isOnline) {
      _pendingWrites.add(progress);
      return;
    }
    await _syncRepository.upsert(uid, progress);
  }

  Future<void> _flushPending(String uid) async {
    if (_pendingWrites.isEmpty &&
        _pendingLivesWrite == null &&
        !_pendingStatsSync &&
        !_pendingDailyGoalSync) {
      return;
    }
    if (!await _isOnline) return;
    final pending = List<LessonProgressModel>.from(_pendingWrites);
    _pendingWrites.clear();
    for (final progress in pending) {
      await _syncRepository.upsert(uid, progress);
    }
    await _flushPendingLives(uid);
    if (_pendingStatsSync) {
      await _syncStatsToFirestore(force: true);
    }
    if (_pendingDailyGoalSync) {
      await _pushDailyGoal();
    }
  }

  Future<void> _pushLives(int lives) async {
    final uid = _uid;
    if (uid == null) return;
    if (!await _isOnline) return;

    await _userRepository.updateLives(uid: uid, lives: lives);
    if (_pendingLivesWrite == lives) {
      _pendingLivesWrite = null;
    }
  }

  Future<void> _flushPendingLives(String uid) async {
    final pending = _pendingLivesWrite;
    if (pending == null) return;
    if (!await _isOnline) return;

    await _userRepository.updateLives(uid: uid, lives: pending);
    if (_pendingLivesWrite == pending) {
      _pendingLivesWrite = null;
    }
  }

  Future<void> _pullLives(String uid) async {
    if (await _isOnline && _pendingLivesWrite == null) {
      final remote = await _userRepository.fetchHeartState(uid);
      if (remote != null) {
        await _localStorage.saveLives(remote.lives);
        final resetDate = remote.lastHeartResetDate;
        if (resetDate != null && resetDate.isNotEmpty) {
          await _localStorage.setLastHeartResetDate(resetDate);
        }
      }
    }
    await _reconcileDailyHearts();
  }

  /// Apply the local calendar refill, then write the result to Firestore so
  /// sign-out / another device sees the same remaining hearts.
  Future<void> _reconcileDailyHearts() async {
    if (_entitlementsService.hasUnlimitedHearts) return;

    final beforeLives = _localStorage.lives;
    final beforeDate = _localStorage.lastHeartResetDate;
    await _entitlementsService.ensureDailyHeartsReset();
    if (_localStorage.lives == beforeLives &&
        _localStorage.lastHeartResetDate == beforeDate) {
      return;
    }
    await onLivesChanged(_localStorage.lives);
  }

  Future<void> ensureLessonXpBackfill() async {
    await _progressRepository.initialize();
    await _backfillLessonXpAwardedFlags();
    await _migrateBackfillLessonXpGrants();
  }

  Future<void> syncOnConnectivityRestored() async {
    await pullAndMerge();
  }

  Future<void> _syncStatsToFirestore({bool force = false}) async {
    final uid = _uid;
    if (uid == null) {
      _pendingStatsSync = true;
      return;
    }
    if (!await _isOnline) {
      _pendingStatsSync = true;
      return;
    }
    if (!force && !_pendingStatsSync) {
      return;
    }

    try {
      await _userRepository.syncLearningStatsFromLocal(uid);
      _pendingStatsSync = false;
      if (kDebugMode) {
        debugPrint(
          'Firestore: learning stats synced → users/$uid '
          '(xpEarned=${_localStorage.xpEarned})',
        );
      }
    } catch (e, stack) {
      _pendingStatsSync = true;
      if (kDebugMode) {
        debugPrint('Firestore learning stats sync failed: $e\n$stack');
      }
    }
  }

  Future<void> syncStatsToFirestore() async {
    _pendingStatsSync = true;
    await _syncStatsToFirestore(force: true);
    _notifyMerged();
  }

  Future<bool> hasLessonXpBoostClaimed(String lessonKey) =>
      _localStorage.hasXpBoostClaimed(lessonKey);

  Future<bool> claimLessonXpBoost({
    required String lessonKey,
    int boostAmount = LessonXpRewards.rewardedBoost,
  }) async {
    if (await _localStorage.hasXpBoostClaimed(lessonKey)) return false;

    await _localStorage.markXpBoostClaimed(lessonKey);
    await _localStorage.addXp(boostAmount);
    _pendingStatsSync = true;
    await _learningStatsService.reconcileFromProgress();
    await _syncStatsToFirestore(force: true);
    _notifyMerged();
    return true;
  }

  Future<void> recordCorrections(int count) async {
    await _learningStatsService.recordCorrections(count);
    if (count <= 0) return;
    await syncStatsToFirestore();
  }

  Future<void> _pullDailyGoal(String uid) async {
    if (!await _isOnline) return;

    await _entitlementsService.ensureDailyGoalState();
    final remote = await _userRepository.fetchDailyGoal(uid);
    if (remote == null) return;

    final today = _entitlementsService.todayIso();
    final remoteDate = remote['dailyProgressDate'] as String?;
    final remoteProgress = remote['dailyProgressMinutes'] as int?;
    final remoteStreak = remote['streakDays'] as int?;
    final remoteLastActive = remote['lastStreakActiveDate'] as String?;

    final localDate = _localStorage.lastDailyProgressDate;
    final localProgress = _localStorage.dailyProgressMinutes;
    final localStreak = _localStorage.streakDays;
    final localLastActive = _localStorage.lastStreakActiveDate;

    var mergedProgress = localProgress;
    if (remoteDate == today && remoteProgress != null) {
      if (localDate != today) {
        mergedProgress = remoteProgress;
      } else {
        mergedProgress = remoteProgress > localProgress
            ? remoteProgress
            : localProgress;
      }
    }

    var mergedStreak = localStreak;
    if (remoteStreak != null) {
      mergedStreak = remoteStreak > localStreak ? remoteStreak : localStreak;
    }

    String? mergedLastActive = localLastActive;
    if (remoteLastActive != null && remoteLastActive.isNotEmpty) {
      if (localLastActive == null || localLastActive.isEmpty) {
        mergedLastActive = remoteLastActive;
      } else {
        mergedLastActive =
            remoteLastActive.compareTo(localLastActive) >= 0
                ? remoteLastActive
                : localLastActive;
      }
    }

    await _localStorage.saveDailyGoalState(
      dailyProgressMinutes: mergedProgress,
      dailyProgressDate: today,
      streakDays: mergedStreak,
      lastStreakActiveDate: mergedLastActive,
    );
    _notifyMerged();
  }

  Future<void> _pushDailyGoal() async {
    final uid = _uid;
    if (uid == null) {
      _pendingDailyGoalSync = true;
      return;
    }
    if (!await _isOnline) {
      _pendingDailyGoalSync = true;
      return;
    }

    try {
      await _userRepository.syncDailyGoalFromLocal(uid);
      _pendingDailyGoalSync = false;
    } catch (e, stack) {
      _pendingDailyGoalSync = true;
      if (kDebugMode) {
        debugPrint('Firestore daily goal sync failed: $e\n$stack');
      }
    }
  }

  Future<void> _pullStats(String uid) async {
    if (!await _isOnline) return;

    final remote = await _userRepository.fetchLearningStats(uid);
    if (remote == null) return;

    await _learningStatsService.mergeRemoteStats(
      xpEarned: remote['xpEarned'],
      wordsLearnedCount: remote['wordsLearnedCount'],
      lessonsCompletedCount: remote['lessonsCompletedCount'],
      correctionsCount: remote['correctionsCount'],
    );
  }
}
