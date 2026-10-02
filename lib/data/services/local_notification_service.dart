import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluentta_ai/core/storage/local_storage.dart';
import 'package:fluentta_ai/l10n/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static const int _dailyReminderId = 1001;
  /// Older builds queued one alarm per day. Cancel that range on reschedule.
  static const int _legacyScheduledDays = 14;
  static const String _channelId = 'daily_practice_reminder';
  static const String _channelName = 'Daily practice reminders';
  static const String pushChannelId = 'fluenta_push';
  static const String _pushChannelName = 'Fluenta';
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

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            pushChannelId,
            _pushChannelName,
            description: 'Practice reminders and announcements from Fluenta',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );

    _initialized = true;
  }

  Future<void> showIncomingPush({
    String? title,
    String? body,
  }) async {
    await initialize();
    final resolvedTitle = (title ?? '').trim();
    final resolvedBody = (body ?? '').trim();
    if (resolvedTitle.isEmpty && resolvedBody.isEmpty) return;

    const androidDetails = AndroidNotificationDetails(
      pushChannelId,
      _pushChannelName,
      channelDescription: 'Practice reminders and announcements from Fluenta',
      importance: Importance.high,
      priority: Priority.high,
      icon: _androidIcon,
      playSound: true,
      enableVibration: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      resolvedTitle.isEmpty ? 'Fluenta' : resolvedTitle,
      resolvedBody,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    try {
      final timeZoneName = (await FlutterTimezone.getLocalTimezone()).trim();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      return;
    } catch (e) {
      debugPrint('LocalNotificationService timezone lookup failed: $e');
    }

    // Zone id from the OS can be missing from the bundled database. A fixed
    // Etc/GMT zone still keeps the reminder on the device's wall clock.
    // Etc/GMT signs are inverted: UTC+5 is Etc/GMT-5.
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final remainderMinutes = offset.inMinutes - (hours * 60);
    if (remainderMinutes == 0 && hours.abs() <= 14) {
      final etcName = hours == 0
          ? 'Etc/UTC'
          : 'Etc/GMT${hours > 0 ? '-' : '+'}${hours.abs()}';
      try {
        tz.setLocalLocation(tz.getLocation(etcName));
        return;
      } catch (e) {
        debugPrint('LocalNotificationService offset timezone failed: $e');
      }
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
      return notificationsGranted ?? false;
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
    if (!storage.hasShownNotificationPrompt) return;
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
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      scheduled = tz.TZDateTime(
        tz.local,
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        hour,
        minute,
      );
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
      category: AndroidNotificationCategory.reminder,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    Future<void> schedule(AndroidScheduleMode mode) {
      return _plugin.zonedSchedule(
        _dailyReminderId,
        title,
        body,
        firstFire,
        details,
        androidScheduleMode: mode,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    try {
      await schedule(scheduleMode);
    } catch (e) {
      debugPrint('LocalNotificationService schedule failed ($scheduleMode): $e');
      if (scheduleMode == AndroidScheduleMode.exactAllowWhileIdle) {
        await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
      } else {
        rethrow;
      }
    }

    if (kDebugMode) {
      final pending = await _plugin.pendingNotificationRequests();
      debugPrint(
        'LocalNotificationService: daily reminder at ${firstFire.toLocal()} '
        '(${tz.local.name}, mode: $scheduleMode, pending: ${pending.length})',
      );
    }
  }

  Future<void> cancelDailyReminder() async {
    await initialize();
    await _plugin.cancel(_dailyReminderId);
    for (var i = 1; i < _legacyScheduledDays; i++) {
      await _plugin.cancel(_dailyReminderId + i);
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
