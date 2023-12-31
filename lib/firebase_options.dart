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
    apiKey: 'AIzaSyA9K06HDuipawnWcaIZCDfxToJKtSaPfWE',
    appId: '1:859145064463:web:c0f2d98650de775e3c937a',
    messagingSenderId: '859145064463',
    projectId: 'devrel-extensions-testing',
    authDomain: 'devrel-extensions-testing.firebaseapp.com',
    storageBucket: 'devrel-extensions-testing.appspot.com',
    measurementId: 'G-1XXPH1LMQH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBI0iMHaeF8w3q10DUUTnMynuSaARJZt4A',
    appId: '1:859145064463:android:44471b2c96d0c5b93c937a',
    messagingSenderId: '859145064463',
    projectId: 'devrel-extensions-testing',
    storageBucket: 'devrel-extensions-testing.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB7qg8TR576yBK0lInrU7LgKm9ED8LqqY0',
    appId: '1:859145064463:ios:717b435dfa5df2ff3c937a',
    messagingSenderId: '859145064463',
    projectId: 'devrel-extensions-testing',
    storageBucket: 'devrel-extensions-testing.appspot.com',
    iosClientId: '859145064463-u31qgeufrjcqccvg518d8hdaulob4if3.apps.googleusercontent.com',
    iosBundleId: 'com.example.imageTextExtraction',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB7qg8TR576yBK0lInrU7LgKm9ED8LqqY0',
    appId: '1:859145064463:ios:717b435dfa5df2ff3c937a',
    messagingSenderId: '859145064463',
    projectId: 'devrel-extensions-testing',
    storageBucket: 'devrel-extensions-testing.appspot.com',
    iosClientId: '859145064463-u31qgeufrjcqccvg518d8hdaulob4if3.apps.googleusercontent.com',
    iosBundleId: 'com.example.imageTextExtraction',
  );
}
