import 'package:flutter/material.dart';
import 'package:fluentta_ai/core/l10n/locale_view_model.dart';
import 'package:fluentta_ai/core/l10n/localized_content.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:intl/intl.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._localStorage, this._localeViewModel) {
    _localeViewModel.addListener(notifyListeners);
    _loadFromStorage();
  }

  final LocalStorage _localStorage;
  final LocaleViewModel _localeViewModel;

  bool _notificationsEnabled = true;
  bool _dailyReminderEnabled = true;
  int _reminderHour = 20;
  int _reminderMinute = 0;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyReminderEnabled => _dailyReminderEnabled;
  int get reminderHour => _reminderHour;
  int get reminderMinute => _reminderMinute;

  int get xpEarned => _localStorage.xpEarned;
  int get wordsCount => _localStorage.wordsLearnedCount;
  int get lessonsCount => _localStorage.lessonsCompletedCount;
  int get correctionsCount => _localStorage.correctionsCount;

  int get dailyGoalMinutes => _localStorage.dailyGoalMinutes ?? 10;
  int get dailyProgressMinutes => _localStorage.dailyProgressMinutes;
  int get streakDays => _localStorage.streakDays;
  int get lives => _localStorage.lives;

  double get lessonProgress => _localStorage.lessonProgress;
  int get progressPercent => (lessonProgress * 100).round();

  double get dailyGoalPercent {
    if (dailyGoalMinutes <= 0) return 0;
    return (dailyProgressMinutes / dailyGoalMinutes).clamp(0.0, 1.0);
  }

  int get dailyGoalPercentLabel => (dailyGoalPercent * 100).round();

  String get levelLabel {
    final l10n = _localeViewModel.strings;
    final code = LocalizedContent.levelCode(
      l10n,
      _localStorage.englishLevel,
    );
    final name = switch (_localStorage.englishLevel) {
      'elementary' => l10n.levelElementary,
      'intermediate' => l10n.levelIntermediate,
      'advanced' => l10n.levelAdvanced,
      _ => l10n.levelBeginner,
    };
    return '$code $name';
  }

  TimeOfDay get reminderTime =>
      TimeOfDay(hour: _reminderHour, minute: _reminderMinute);

  String formattedReminderTime(BuildContext context) {
    final locale = _localeViewModel.locale.toString();
    final date = DateTime(2024, 1, 1, _reminderHour, _reminderMinute);
    return DateFormat.jm(locale).format(date);
  }

  void _loadFromStorage() {
    _notificationsEnabled = _localStorage.notificationsEnabled;
    _dailyReminderEnabled = _localStorage.dailyReminderEnabled;
    _reminderHour = _localStorage.reminderHour;
    _reminderMinute = _localStorage.reminderMinute;
  }

  void refresh() {
    _loadFromStorage();
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    await _localStorage.setNotificationsEnabled(value);
    if (!value) {
      _dailyReminderEnabled = false;
      await _localStorage.setDailyReminderEnabled(false);
    }
    notifyListeners();
  }

  Future<void> setDailyReminderEnabled(bool value) async {
    _dailyReminderEnabled = value;
    await _localStorage.setDailyReminderEnabled(value);
    if (value) {
      _notificationsEnabled = true;
      await _localStorage.setNotificationsEnabled(true);
    }
    notifyListeners();
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    _reminderHour = time.hour;
    _reminderMinute = time.minute;
    await _localStorage.setReminderTime(
      hour: time.hour,
      minute: time.minute,
    );
    notifyListeners();
  }

  void setPendingReminderTime(TimeOfDay time) {
    _reminderHour = time.hour;
    _reminderMinute = time.minute;
    notifyListeners();
  }

  @override
  void dispose() {
    _localeViewModel.removeListener(notifyListeners);
    super.dispose();
  }
}
