import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Инициализация FCM
  Future<void> initialize() async {
    // Запрашиваем разрешение на уведомления
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Получаем FCM токен
      String? token = await _messaging.getToken();
      if (token != null) {
        await _saveTokenToDatabase(token);
      }

      // Слушаем обновления токена
      _messaging.onTokenRefresh.listen(_saveTokenToDatabase);
    }
  }

  // Сохранение токена в Firestore
  Future<void> _saveTokenToDatabase(String token) async {
    String? userId = _auth.currentUser?.uid;
    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (!userDoc.exists) {
        // Если документ не существует, создаем его
        await _firestore.collection('users').doc(userId).set({
          'fcmTokens': [token],
          'lastTokenUpdate': DateTime.now().toIso8601String(),
        });
      } else {
        // Если документ существует, обновляем его
        await _firestore.collection('users').doc(userId).update({
          'fcmTokens': FieldValue.arrayUnion([token]),
          'lastTokenUpdate': DateTime.now().toIso8601String(),
        });
      }
    }
  }

  // Получение текущего FCM токена
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
} 