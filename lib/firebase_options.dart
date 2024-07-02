// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyAMT4ULFabXVDkzTTDhcGVOqdccUzGibvU',
    appId: '1:303267514075:web:312841b5a1577ef3edeefe',
    messagingSenderId: '303267514075',
    projectId: 'hermes-fac12',
    authDomain: 'hermes-fac12.firebaseapp.com',
    storageBucket: 'hermes-fac12.appspot.com',
    measurementId: 'G-MP6KNBVH55',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDj_XpyFAsGinp9FCuAdG6zf0m0P9O64dE',
    appId: '1:303267514075:android:c3225d6906742e1aedeefe',
    messagingSenderId: '303267514075',
    projectId: 'hermes-fac12',
    storageBucket: 'hermes-fac12.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOB47GrzjODhlE08mTHivprk1KZSnrz5Q',
    appId: '1:303267514075:ios:4d623ec325629cf6edeefe',
    messagingSenderId: '303267514075',
    projectId: 'hermes-fac12',
    storageBucket: 'hermes-fac12.appspot.com',
    iosBundleId: 'com.example.hermes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOB47GrzjODhlE08mTHivprk1KZSnrz5Q',
    appId: '1:303267514075:ios:a8ad8a51e4f62144edeefe',
    messagingSenderId: '303267514075',
    projectId: 'hermes-fac12',
    storageBucket: 'hermes-fac12.appspot.com',
    iosBundleId: 'com.example.hermes.RunnerTests',
  );
}
