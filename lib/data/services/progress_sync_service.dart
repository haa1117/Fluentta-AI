import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
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
    Connectivity? connectivity,
  })  : _progressRepository = progressRepository,
        _syncRepository = syncRepository,
        _userRepository = userRepository,
        _localStorage = localStorage,
        _learningStatsService = learningStatsService,
        _connectivity = connectivity ?? Connectivity();

  final ProgressRepository _progressRepository;
  final ProgressSyncRepository _syncRepository;
  final UserRepository _userRepository;
  final LocalStorage _localStorage;
  final LearningStatsService _learningStatsService;
  final Connectivity _connectivity;

  final List<LessonProgressModel> _pendingWrites = [];
  int? _pendingLivesWrite;
  final List<VoidCallback> _mergeListeners = [];

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
    return !result.contains(ConnectivityResult.none);
  }

  String? get _uid => _localStorage.userUid;

  Future<void> pullAndMerge() async {
    final uid = _uid;
    if (uid == null) return;
    if (!await _isOnline) return;

    await _progressRepository.initialize();
    final remote = await _syncRepository.fetchAll(uid);
    await _progressRepository.mergeRemoteProgress(remote);
    await _flushPending(uid);
    await _pullLives(uid);
    await _pullStats(uid);
    await _learningStatsService.reconcileFromProgress();
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
    await _progressRepository.saveProgress(progress);
    await _localStorage.addXp(25);
    if (wordsLearned > 0) {
      await _localStorage.incrementWordsLearned(wordsLearned);
    }
    await _learningStatsService.reconcileFromProgress();
    await _syncStatsToFirestore();
    await _pushProgress(progress);
    _notifyMerged();
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
    if (_pendingWrites.isEmpty && _pendingLivesWrite == null) return;
    if (!await _isOnline) return;
    final pending = List<LessonProgressModel>.from(_pendingWrites);
    _pendingWrites.clear();
    for (final progress in pending) {
      await _syncRepository.upsert(uid, progress);
    }
    await _flushPendingLives(uid);
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
    if (!await _isOnline) return;
    if (_pendingLivesWrite != null) return;

    final remoteLives = await _userRepository.fetchLives(uid);
    if (remoteLives == null) return;

    await _localStorage.saveLives(remoteLives);
    _notifyMerged();
  }

  Future<void> syncOnConnectivityRestored() async {
    await pullAndMerge();
  }

  Future<void> _syncStatsToFirestore() async {
    final uid = _uid;
    if (uid == null || !await _isOnline) return;
    await _userRepository.updateLearningStats(
      uid: uid,
      xpEarned: _localStorage.xpEarned,
      lessonsCompletedCount: _localStorage.lessonsCompletedCount,
      wordsLearnedCount: _localStorage.wordsLearnedCount,
      correctionsCount: _localStorage.correctionsCount,
    );
  }

  Future<void> syncStatsToFirestore() async {
    await _syncStatsToFirestore();
    _notifyMerged();
  }

  Future<void> recordCorrections(int count) async {
    await _learningStatsService.recordCorrections(count);
    if (count <= 0) return;
    await syncStatsToFirestore();
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
