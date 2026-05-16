import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';
import '../services/secure_storage_service.dart';
import '../services/user_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  debugPrint("Background message: ${message.messageId}");
  debugPrint("   Title: ${message.notification?.title}");
  debugPrint("   Body: ${message.notification?.body}");
}

class FCMService {
  FCMService._();
  static final FCMService instance = FCMService._();
  late final FirebaseMessaging _firebaseMessaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;
  final UserService _userService = UserService();
  final SecureStorageService _storageService = SecureStorageService();

  void Function(String eventId)? onEventSelected;
  void Function()? onNewEventNotification;

  void setOnEventSelected(void Function(String eventId) callback) {
    onEventSelected = callback;
  }

  void setOnNewEventNotification(void Function() callback) {
    onNewEventNotification = callback;
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    _firebaseMessaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    // Request permissions for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    final apnsToken = await _firebaseMessaging.getAPNSToken();

    if (apnsToken == null) {
      debugPrint(
        "APNs Token is null, user may have declined permissions or device may not support APNs",
      );
    }

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    try {
      final token = await _firebaseMessaging.getToken();

      if (token != null) {
        await _updateFcmTokenOnBackend(token);
      }
    } catch (e) {
      debugPrint("Unable to get FCM token: $e");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message: ${message.messageId}");
      _handleForegroundMessage(message);
      if (message.data.containsKey('eventId')) {
        onNewEventNotification?.call();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Message opened from notification: ${message.messageId}");
      if (message.data.containsKey('eventId')) {
        onNewEventNotification?.call();
      }
      _handleNotificationTap(message);
    });

    _firebaseMessaging.onTokenRefresh
        .listen((token) async {
          debugPrint("FCM Token refreshed: $token");
          await _updateFcmTokenOnBackend(token);
        })
        .onError((err) {
          debugPrint("Error refreshing FCM token: $err");
        });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint("Launched via notification: ${initialMessage.data}");
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      await _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  Future<void> _updateFcmTokenOnBackend(String fcmToken) async {
    try {
      final jwtToken = await _storageService.getToken(
        SecureStorageService.jwtTokenKey,
      );

      if (jwtToken != null && jwtToken.isNotEmpty) {
        final isExpired = await _storageService.isAuthTokenExpired();
        if (!isExpired) {
          await _userService.updateFcmToken(jwtToken, fcmToken);
        } else {
          debugPrint("JWT token expired, cannot update FCM token");
        }
      } else {
        debugPrint("No JWT token found, user may not be logged in yet");
      }
    } catch (e) {
      debugPrint("Error updating FCM token on backend: $e");
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    _handleNotificationPayload(response.payload);
  }

  void _handleNotificationTap(RemoteMessage message, {BuildContext? context}) {
    final eventId = message.data['eventId']?.toString();
    if (eventId != null && eventId.isNotEmpty) {
      debugPrint("Handling event navigation callback for ID: $eventId");
      _handleEventNavigation(eventId, context: context);
    } else {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open event details: event information missing',
            ),
          ),
        );
      }
      debugPrint("FCM message data does not contain eventId");
    }
  }

  void _handleNotificationPayload(String? payload, {BuildContext? context}) {
    if (payload == null || payload.isEmpty) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open event details: event information missing',
            ),
          ),
        );
      }
      debugPrint("No payload to handle");
      return;
    }

    try {
      final eventData = jsonDecode(payload) as Map<String, dynamic>;
      final eventId = eventData['eventId']?.toString();

      if (eventId != null && eventId.isNotEmpty) {
        debugPrint("Handling event navigation callback for ID: $eventId");
        _handleEventNavigation(eventId, context: context);
      } else {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to open event details: event information missing',
              ),
            ),
          );
        }
        debugPrint("FCM payload does not contain eventId");
      }
    } catch (e) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open event details: event information missing',
            ),
          ),
        );
      }
      debugPrint("Failed to parse notification payload as JSON: $e");
    }
  }

  Future<void> _handleEventNavigation(
    String eventId, {
    BuildContext? context,
  }) async {
    try {
      final jwtToken = await _storageService.getToken(
        SecureStorageService.jwtTokenKey,
      );
      final isExpired = await _storageService.isAuthTokenExpired();

      if (jwtToken == null || isExpired) {
        await _storageService.savePendingEventId(eventId);
      } else {
        onEventSelected?.call(eventId);
      }
    } catch (e) {
      debugPrint("Error handling event navigation: $e");
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to open event details: event information missing',
            ),
          ),
        );
      }
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> updateTokenOnBackend() async {
    final token = await getToken();
    if (token != null) {
      await _updateFcmTokenOnBackend(token);
    } else {
      debugPrint("No FCM token available to send");
    }
  }
}
