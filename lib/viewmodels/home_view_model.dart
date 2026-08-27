import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/data/services/entitlements_service.dart';
import 'package:fluentta_ai/data/services/progress_sync_service.dart';

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
  int _dailyGoalMinutes = 10;
  int _streakDays = 1;
  int _lives = 5;
  int _xpEarned = 0;
  double _lessonProgress = 0.35;

  int get dailyProgressMinutes => _dailyProgressMinutes;
  int get dailyGoalMinutes => _dailyGoalMinutes;
  int get streakDays => _streakDays;
  int get lives => _lives;
  int get xpEarned => _xpEarned;
  double get lessonProgress => _lessonProgress;
  bool get isPro => _entitlementsService.isPro;
  bool get hasUnlimitedHearts => _entitlementsService.hasUnlimitedHearts;
  int get dailyHeartAllowance => _entitlementsService.dailyHeartAllowance;
  int get streakFreezesRemaining => _entitlementsService.streakFreezesRemaining;

  double get dailyGoalPercent {
    if (_dailyGoalMinutes <= 0) return 0;
    return (_dailyProgressMinutes / _dailyGoalMinutes).clamp(0.0, 1.0);
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
    await _entitlementsService.ensureDailyHeartsReset();
    _loadFromStorage();
    notifyListeners();
  }

  void _loadFromStorage() {
    _dailyGoalMinutes = _localStorage.dailyGoalMinutes ?? 10;
    _dailyProgressMinutes = _localStorage.dailyProgressMinutes;
    _streakDays = _localStorage.streakDays;
    _lives = _localStorage.lives;
    _xpEarned = _localStorage.xpEarned;
    _lessonProgress = _localStorage.lessonProgress;
  }

  Future<void> startAiChat(VoidCallback onComplete) async {
    await _localStorage.incrementDailyProgress(2);
    await _entitlementsService.recordLearningActivity();
    _loadFromStorage();
    notifyListeners();
    onComplete();
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

  Future<void> recordLearningActivity() async {
    await _entitlementsService.recordLearningActivity();
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

  @override
  void dispose() {
    _progressSyncService.removeMergeListener(refresh);
    super.dispose();
  }
}
