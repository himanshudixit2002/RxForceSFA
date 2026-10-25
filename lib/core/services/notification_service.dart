import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/database.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  GoRouter? _router;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void setRouter(GoRouter router) => _router = router;

  Future<void> initialize() async {
    if (kIsWeb) return;
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      debugPrint('FCM Token: $token');

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      await _localNotifications.initialize(
        const InitializationSettings(android: androidSettings, iOS: iosSettings),
        onDidReceiveNotificationResponse: _onLocalNotificationTap,
      );

      FirebaseMessaging.onMessage.listen(_handleForeground);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackground);

      final initial = await messaging.getInitialMessage();
      if (initial != null) _navigateFromMessage(initial);
    } catch (e) {
      debugPrint('FCM init error: $e');
    }
  }

  void _handleForeground(RemoteMessage message) {
    debugPrint('Foreground message: ${message.notification?.title}');
    _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails('sfa_channel', 'SFA Notifications', importance: Importance.high),
        iOS: DarwinNotificationDetails(),
      ),
      payload: _buildPayload(message.data),
    );
  }

  void _handleBackground(RemoteMessage message) {
    debugPrint('Background tap: ${message.notification?.title}');
    _navigateFromMessage(message);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    final parts = payload.split('|');
    if (parts.length == 2) {
      final route = _routeForType(parts[0], parts[1]);
      _router?.go(route);
    }
  }

  void _navigateFromMessage(RemoteMessage message) {
    final type = message.data['type'] as String? ?? '';
    final referenceId = message.data['referenceId'] as String? ?? '';
    if (type.isNotEmpty) {
      final route = _routeForType(type, referenceId);
      _router?.go(route);
    }
  }

  String _buildPayload(Map<String, dynamic> data) {
    return '${data['type'] ?? ''}|${data['referenceId'] ?? ''}';
  }

  static String routeForNotification(NotificationType type, String referenceId) {
    return _routeForTypeEnum(type, referenceId);
  }

  static String _routeForTypeEnum(NotificationType type, String referenceId) {
    switch (type) {
      case NotificationType.approvalRequest:
        return '/approvals/$referenceId';
      case NotificationType.approvalResult:
        return '/approvals/$referenceId';
      case NotificationType.reminder:
        return '/tour-plan';
      case NotificationType.alert:
        return '/notifications';
      case NotificationType.system:
        return '/notifications';
    }
  }

  static String _routeForType(String type, String referenceId) {
    switch (type) {
      case 'approvalRequest':
        return '/approvals/$referenceId';
      case 'approvalResult':
        return '/approvals/$referenceId';
      case 'reminder':
        return '/tour-plan';
      case 'order':
        return '/orders/$referenceId';
      case 'expense':
        return '/expenses';
      case 'leave':
        return '/leave';
      default:
        return '/notifications';
    }
  }
}
