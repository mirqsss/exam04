// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCFcJ3BVIUqdxEA_17b1txMeAEcMxR2CLg',
    appId: '1:296718407969:web:bf1b25256f92e3e25d0660',
    messagingSenderId: '296718407969',
    projectId: 'exam04-8a0f3',
    authDomain: 'exam04-8a0f3.firebaseapp.com',
    storageBucket: 'exam04-8a0f3.firebasestorage.app',
    measurementId: 'G-8DEJPDVM38',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9viUX6K4BIJZGRs9KJdArfOUqcV6VmVA',
    appId: '1:296718407969:android:f8e86362db857f995d0660',
    messagingSenderId: '296718407969',
    projectId: 'exam04-8a0f3',
    storageBucket: 'exam04-8a0f3.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnfaPgA7_0IiO3xUsY_eYOggBHVPQLmP8',
    appId: '1:296718407969:ios:b987c28da1e793555d0660',
    messagingSenderId: '296718407969',
    projectId: 'exam04-8a0f3',
    storageBucket: 'exam04-8a0f3.firebasestorage.app',
    iosBundleId: 'com.example.exam04',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnfaPgA7_0IiO3xUsY_eYOggBHVPQLmP8',
    appId: '1:296718407969:ios:b987c28da1e793555d0660',
    messagingSenderId: '296718407969',
    projectId: 'exam04-8a0f3',
    storageBucket: 'exam04-8a0f3.firebasestorage.app',
    iosBundleId: 'com.example.exam04',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCFcJ3BVIUqdxEA_17b1txMeAEcMxR2CLg',
    appId: '1:296718407969:web:896a508cd9e0ce215d0660',
    messagingSenderId: '296718407969',
    projectId: 'exam04-8a0f3',
    authDomain: 'exam04-8a0f3.firebaseapp.com',
    storageBucket: 'exam04-8a0f3.firebasestorage.app',
    measurementId: 'G-ZTD4WYEXPB',
  );

}