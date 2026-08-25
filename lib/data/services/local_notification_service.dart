import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static const int _dailyReminderBaseId = 1001;
  static const int _scheduledDaysAhead = 14;
  static const String _channelId = 'daily_practice_reminder';
  static const String _channelName = 'Daily practice reminders';
  static const String _androidIcon = '@drawable/ic_notification';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    await _configureLocalTimeZone();

    const androidSettings = AndroidInitializationSettings(_androidIcon);
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: 'Daily reminders to practice English',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );

    _initialized = true;
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('LocalNotificationService timezone fallback: $e');
      }
      tz.setLocalLocation(tz.local);
    }
  }

  Future<bool> hasNotificationPermission() async {
    await initialize();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      return await android?.areNotificationsEnabled() ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final settings = await ios?.checkPermissions();
      return settings?.isEnabled ?? false;
    }

    return true;
  }

  Future<bool> requestPermissions() async {
    await initialize();

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return false;

      final notificationsGranted =
          await android.requestNotificationsPermission();
      if (notificationsGranted != true) {
        return false;
      }

      final canScheduleExact =
          await android.canScheduleExactNotifications() ?? false;
      if (!canScheduleExact) {
        await android.requestExactAlarmsPermission();
      }

      return await android.areNotificationsEnabled() ?? false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios == null) return false;

      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  Future<void> bootstrapReminders({
    required LocalStorage storage,
    required AppLocalizations l10n,
  }) async {
    if (!storage.notificationsEnabled || !storage.dailyReminderEnabled) {
      await cancelDailyReminder();
      return;
    }

    final granted = await requestPermissions();
    if (!granted) {
      if (kDebugMode) {
        debugPrint('LocalNotificationService: notification permission denied');
      }
      return;
    }

    await syncFromStorage(storage, l10n);
  }

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }

    final canScheduleExact =
        await android.canScheduleExactNotifications() ?? false;
    if (canScheduleExact) {
      return AndroidScheduleMode.exactAllowWhileIdle;
    }

    return AndroidScheduleMode.inexactAllowWhileIdle;
  }

  tz.TZDateTime _nextReminderTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    await initialize();
    await _configureLocalTimeZone();

    if (!await hasNotificationPermission()) {
      if (kDebugMode) {
        debugPrint(
          'LocalNotificationService: skip schedule — no notification permission',
        );
      }
      return;
    }

    await cancelDailyReminder();

    final firstFire = _nextReminderTime(hour, minute);
    final scheduleMode = await _resolveAndroidScheduleMode();

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Daily reminders to practice English',
      importance: Importance.max,
      priority: Priority.high,
      icon: _androidIcon,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    var scheduledCount = 0;
    for (var dayOffset = 0; dayOffset < _scheduledDaysAhead; dayOffset++) {
      final scheduled = firstFire.add(Duration(days: dayOffset));

      try {
        await _plugin.zonedSchedule(
          _dailyReminderBaseId + dayOffset,
          title,
          body,
          scheduled,
          details,
          androidScheduleMode: scheduleMode,
        );
        scheduledCount++;
      } catch (e) {
        if (scheduleMode == AndroidScheduleMode.exactAllowWhileIdle) {
          try {
            await _plugin.zonedSchedule(
              _dailyReminderBaseId + dayOffset,
              title,
              body,
              scheduled,
              details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            );
            scheduledCount++;
            continue;
          } catch (retryError) {
            if (kDebugMode) {
              debugPrint(
                'LocalNotificationService schedule retry failed for '
                'day $dayOffset: $retryError',
              );
            }
          }
        }

        if (kDebugMode) {
          debugPrint(
            'LocalNotificationService schedule failed for day $dayOffset: $e',
          );
        }
      }
    }

    if (kDebugMode) {
      final pending = await _plugin.pendingNotificationRequests();
      debugPrint(
        'LocalNotificationService: scheduled $scheduledCount reminders. '
        'First at ${firstFire.toLocal()} '
        '(${tz.local.name}, mode: $scheduleMode, pending: ${pending.length})',
      );
    }
  }

  Future<void> cancelDailyReminder() async {
    await initialize();
    for (var i = 0; i < _scheduledDaysAhead; i++) {
      await _plugin.cancel(_dailyReminderBaseId + i);
    }
  }

  Future<void> syncFromStorage(
    LocalStorage storage,
    AppLocalizations l10n,
  ) async {
    if (storage.notificationsEnabled && storage.dailyReminderEnabled) {
      await scheduleDailyReminder(
        hour: storage.reminderHour,
        minute: storage.reminderMinute,
        title: l10n.dailyReminder,
        body: l10n.readyToPractice,
      );
      return;
    }

    await cancelDailyReminder();
  }
}
