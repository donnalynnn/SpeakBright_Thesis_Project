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
    apiKey: 'AIzaSyBHA7H1TQZsuTG_vlIGivUxNugdmtsGJIA',
    appId: '1:823994313736:web:3fe6a2911183c27178f5bd',
    messagingSenderId: '823994313736',
    projectId: 'speakbright-55025',
    authDomain: 'speakbright-55025.firebaseapp.com',
    storageBucket: 'speakbright-55025.appspot.com',
    measurementId: 'G-48PF6C3MYZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDb7rEb9lqz9P_e-beTfVUxGaejt9fJxN0',
    appId: '1:823994313736:android:7774c3c2e6be540578f5bd',
    messagingSenderId: '823994313736',
    projectId: 'speakbright-55025',
    storageBucket: 'speakbright-55025.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBr-sB4xdBYeVceD9jNbDIbvEX62pd_PHE',
    appId: '1:823994313736:ios:6a329e6f0a85aa2178f5bd',
    messagingSenderId: '823994313736',
    projectId: 'speakbright-55025',
    storageBucket: 'speakbright-55025.appspot.com',
    iosBundleId: 'com.example.speakbrightMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBr-sB4xdBYeVceD9jNbDIbvEX62pd_PHE',
    appId: '1:823994313736:ios:6a329e6f0a85aa2178f5bd',
    messagingSenderId: '823994313736',
    projectId: 'speakbright-55025',
    storageBucket: 'speakbright-55025.appspot.com',
    iosBundleId: 'com.example.speakbrightMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBHA7H1TQZsuTG_vlIGivUxNugdmtsGJIA',
    appId: '1:823994313736:web:3f208defab308c9178f5bd',
    messagingSenderId: '823994313736',
    projectId: 'speakbright-55025',
    authDomain: 'speakbright-55025.firebaseapp.com',
    storageBucket: 'speakbright-55025.appspot.com',
    measurementId: 'G-VCBWH8GYBJ',
  );
}
