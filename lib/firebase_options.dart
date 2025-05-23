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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB6cjeHXC6UWtHjJwGudjWziLeFHwy8RYk',
    appId: '1:37248952028:web:be3714e1614c30fffc3619',
    messagingSenderId: '37248952028',
    projectId: 'sirozproje',
    authDomain: 'sirozproje.firebaseapp.com',
    storageBucket: 'sirozproje.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtFMKqlh5dV-zDz_Jkvax2VzYWAxEVfXQ',
    appId: '1:37248952028:android:3d4501434f07ca07fc3619',
    messagingSenderId: '37248952028',
    projectId: 'sirozproje',
    storageBucket: 'sirozproje.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAggQrDOB_Q3kUTMZBGPm8UCqbhNHWBT8E',
    appId: '1:37248952028:ios:14eeb8c079b9fdf4fc3619',
    messagingSenderId: '37248952028',
    projectId: 'sirozproje',
    storageBucket: 'sirozproje.firebasestorage.app',
    iosBundleId: 'com.example.siroz',
  );
}
