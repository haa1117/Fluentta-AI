import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/models/lesson_progress_model.dart';
import 'package:fluentta_ai/data/repositories/progress_repository.dart';
import 'package:fluentta_ai/data/repositories/progress_sync_repository.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';

class ProgressSyncService {
  ProgressSyncService({
    required ProgressRepository progressRepository,
    required ProgressSyncRepository syncRepository,
    required UserRepository userRepository,
    required LocalStorage localStorage,
    Connectivity? connectivity,
  })  : _progressRepository = progressRepository,
        _syncRepository = syncRepository,
        _userRepository = userRepository,
        _localStorage = localStorage,
        _connectivity = connectivity ?? Connectivity();

  final ProgressRepository _progressRepository;
  final ProgressSyncRepository _syncRepository;
  final UserRepository _userRepository;
  final LocalStorage _localStorage;
  final Connectivity _connectivity;

  final List<LessonProgressModel> _pendingWrites = [];

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
    await _localStorage.incrementLessonsCompleted();
    await _localStorage.addXp(25);
    if (wordsLearned > 0) {
      await _localStorage.incrementWordsLearned(wordsLearned);
    }
    await _syncStatsToFirestore();
    await _pushProgress(progress);
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
    if (_pendingWrites.isEmpty) return;
    if (!await _isOnline) return;
    final pending = List<LessonProgressModel>.from(_pendingWrites);
    _pendingWrites.clear();
    for (final progress in pending) {
      await _syncRepository.upsert(uid, progress);
    }
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
    );
  }
}
