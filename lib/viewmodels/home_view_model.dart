import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._localStorage) {
    _loadFromStorage();
  }

  final LocalStorage _localStorage;

  int _dailyProgressMinutes = 0;
  int _dailyGoalMinutes = 10;
  int _streakDays = 1;
  int _lives = 5;
  double _lessonProgress = 0.35;

  int get dailyProgressMinutes => _dailyProgressMinutes;
  int get dailyGoalMinutes => _dailyGoalMinutes;
  int get streakDays => _streakDays;
  int get lives => _lives;
  double get lessonProgress => _lessonProgress;

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

  void _loadFromStorage() {
    _dailyGoalMinutes = _localStorage.dailyGoalMinutes ?? 10;
    _dailyProgressMinutes = _localStorage.dailyProgressMinutes;
    _streakDays = _localStorage.streakDays;
    _lives = _localStorage.lives;
    _lessonProgress = _localStorage.lessonProgress;
  }

  Future<void> startAiChat(VoidCallback onComplete) async {
    await _localStorage.incrementDailyProgress(2);
    _loadFromStorage();
    notifyListeners();
    onComplete();
  }

  Future<bool> useHeart() async {
    if (_lives <= 0) return false;
    await _localStorage.saveLives(_lives - 1);
    _loadFromStorage();
    notifyListeners();
    return true;
  }

  Future<void> addHearts(int count) async {
    await _localStorage.saveLives(_lives + count);
    _loadFromStorage();
    notifyListeners();
  }

  Future<void> resumeLesson(VoidCallback onNavigateToLearn) async {
    await _localStorage.saveLessonProgress(
      (_lessonProgress + 0.1).clamp(0.0, 1.0),
    );
    _loadFromStorage();
    notifyListeners();
    onNavigateToLearn();
  }

  void refresh() {
    _loadFromStorage();
    notifyListeners();
  }
}
