import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Запрос разрешений на уведомления
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Получение FCM токена
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Обработка уведомлений в фоне
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Обработка уведомлений когда приложение открыто
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // Обработчик фоновых уведомлений
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  // Обработка уведомлений когда приложение открыто
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  }
} 