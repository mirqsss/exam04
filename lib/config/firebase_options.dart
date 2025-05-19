import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // TODO: Замените на ваши настройки Firebase
    return const FirebaseOptions(
      apiKey: 'YOUR-API-KEY',
      appId: 'YOUR-APP-ID',
      messagingSenderId: 'YOUR-SENDER-ID',
      projectId: 'YOUR-PROJECT-ID',
      storageBucket: 'YOUR-STORAGE-BUCKET',
    );
  }
} 