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
    apiKey: 'AIzaSyDHn9ZuAdY-uY7eIS38pSckYG-bFW29-HA',
    appId: '1:1021568931129:web:4759d1f565b679370e04e8',
    messagingSenderId: '1021568931129',
    projectId: 'techmart-ecd96',
    authDomain: 'techmart-ecd96.firebaseapp.com',
    storageBucket: 'techmart-ecd96.firebasestorage.app',
    measurementId: 'G-FZXRKZ9WXJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUVTguKYDn67F2itMhBK9gtsEw0TExKUA',
    appId: '1:1021568931129:android:73080cba22f9c5720e04e8',
    messagingSenderId: '1021568931129',
    projectId: 'techmart-ecd96',
    storageBucket: 'techmart-ecd96.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVPxw097Lt6zOQyal_5VNPuYsVn_yynmk',
    appId: '1:1021568931129:ios:1941ab04599616c40e04e8',
    messagingSenderId: '1021568931129',
    projectId: 'techmart-ecd96',
    storageBucket: 'techmart-ecd96.firebasestorage.app',
    androidClientId: '1021568931129-n3ughbd2dck44q92193dht3oalo2n097.apps.googleusercontent.com',
    iosClientId: '1021568931129-q7pldcr8ltf36if633tstkdv7ehbmm0n.apps.googleusercontent.com',
    iosBundleId: 'com.example.techmartSeller',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVPxw097Lt6zOQyal_5VNPuYsVn_yynmk',
    appId: '1:1021568931129:ios:1941ab04599616c40e04e8',
    messagingSenderId: '1021568931129',
    projectId: 'techmart-ecd96',
    storageBucket: 'techmart-ecd96.firebasestorage.app',
    androidClientId: '1021568931129-n3ughbd2dck44q92193dht3oalo2n097.apps.googleusercontent.com',
    iosClientId: '1021568931129-q7pldcr8ltf36if633tstkdv7ehbmm0n.apps.googleusercontent.com',
    iosBundleId: 'com.example.techmartSeller',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDHn9ZuAdY-uY7eIS38pSckYG-bFW29-HA',
    appId: '1:1021568931129:web:c1ab56f10428f2ee0e04e8',
    messagingSenderId: '1021568931129',
    projectId: 'techmart-ecd96',
    authDomain: 'techmart-ecd96.firebaseapp.com',
    storageBucket: 'techmart-ecd96.firebasestorage.app',
    measurementId: 'G-M5Q6DM2323',
  );
}
