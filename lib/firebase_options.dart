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
    apiKey: 'AIzaSyCHDXPl9HoF3sHq7LgxukQRgGBwPFxnZVU',
    appId: '1:727929192659:web:7a8ab442c85a5d0a731426',
    messagingSenderId: '727929192659',
    projectId: 'parking-system-2a748',
    authDomain: 'parking-system-2a748.firebaseapp.com',
    storageBucket: 'parking-system-2a748.firebasestorage.app',
    measurementId: 'G-RPZ328SPZX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcGuWPtI6azURIROMMQF2TsYWGz7Px1oQ',
    appId: '1:727929192659:android:b9d1c63560857cbd731426',
    messagingSenderId: '727929192659',
    projectId: 'parking-system-2a748',
    storageBucket: 'parking-system-2a748.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYTu8Pz3s0KID3-8QZajTHI3qoSTU9AXw',
    appId: '1:727929192659:ios:e0a0dd4981be8b9d731426',
    messagingSenderId: '727929192659',
    projectId: 'parking-system-2a748',
    storageBucket: 'parking-system-2a748.firebasestorage.app',
    iosBundleId: 'com.example.parkingSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYTu8Pz3s0KID3-8QZajTHI3qoSTU9AXw',
    appId: '1:727929192659:ios:e0a0dd4981be8b9d731426',
    messagingSenderId: '727929192659',
    projectId: 'parking-system-2a748',
    storageBucket: 'parking-system-2a748.firebasestorage.app',
    iosBundleId: 'com.example.parkingSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHDXPl9HoF3sHq7LgxukQRgGBwPFxnZVU',
    appId: '1:727929192659:web:f072f0cf0e9b3e10731426',
    messagingSenderId: '727929192659',
    projectId: 'parking-system-2a748',
    authDomain: 'parking-system-2a748.firebaseapp.com',
    storageBucket: 'parking-system-2a748.firebasestorage.app',
    measurementId: 'G-KB3LGVS8GR',
  );
}