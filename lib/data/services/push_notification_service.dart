import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluentta_ai/data/repositories/user_repository.dart';
import 'package:fluentta_ai/data/services/local_notification_service.dart';
import 'package:fluentta_ai/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Notification payloads are shown by the OS while backgrounded.
  if (message.notification != null) return;

  final title = (message.data['title'] ?? '').toString().trim();
  final body = (message.data['body'] ?? '').toString().trim();
  if (title.isEmpty && body.isEmpty) return;

  const androidIcon = '@drawable/ic_notification';
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings(androidIcon),
      iOS: DarwinInitializationSettings(),
    ),
  );
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        const AndroidNotificationChannel(
          LocalNotificationService.pushChannelId,
          'Fluenta',
          importance: Importance.high,
        ),
      );

  await plugin.show(
    message.hashCode,
    title.isEmpty ? 'Fluenta' : title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        LocalNotificationService.pushChannelId,
        'Fluenta',
        importance: Importance.high,
        priority: Priority.high,
        icon: androidIcon,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    ),
  );
}

class PushNotificationService {
  PushNotificationService._();

  static final PushNotificationService instance = PushNotificationService._();

  UserRepository? _userRepository;
  LocalNotificationService? _localNotifications;
  bool _initialized = false;

  Future<void> initialize({
    required UserRepository userRepository,
    required LocalNotificationService localNotifications,
  }) async {
    if (kIsWeb || _initialized) return;
    _userRepository = userRepository;
    _localNotifications = localNotifications;

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken);

    _initialized = true;
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      debugPrint('FCM foreground: ${message.notification?.title}');
    }
    await _localNotifications?.showIncomingPush(
      title: message.notification?.title ?? message.data['title']?.toString(),
      body: message.notification?.body ?? message.data['body']?.toString(),
    );
  }

  Future<void> requestPermissionAndSyncToken() async {
    if (kIsWeb) return;
    try {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _saveToken(token);
      }
    } catch (error) {
      if (kDebugMode) {
        debugPrint('PushNotificationService.request failed: $error');
      }
    }
  }

  Future<void> _saveToken(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final repo = _userRepository;
    if (uid == null || repo == null) return;
    await repo.saveFcmToken(uid: uid, token: token);
  }
}
