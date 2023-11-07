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
    apiKey: 'AIzaSyB5F-QbbVyjDwwuxLL-fUw7CuTXVAeM_oI',
    appId: '1:297170709166:web:db6c81ea33effe01e25b3f',
    messagingSenderId: '297170709166',
    projectId: 'campusmapper-5bbf5',
    authDomain: 'campusmapper-5bbf5.firebaseapp.com',
    storageBucket: 'campusmapper-5bbf5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJXBpSAElE-bxcVBLEdnBXcXXK8Oc7vmM',
    appId: '1:297170709166:android:1226a83390a9612ce25b3f',
    messagingSenderId: '297170709166',
    projectId: 'campusmapper-5bbf5',
    storageBucket: 'campusmapper-5bbf5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBklV3KHYzC4kNVZkhM5_lUXRdz_S0DkLA',
    appId: '1:297170709166:ios:2ba0510030ac946be25b3f',
    messagingSenderId: '297170709166',
    projectId: 'campusmapper-5bbf5',
    storageBucket: 'campusmapper-5bbf5.appspot.com',
    iosBundleId: 'com.example.campusmapper',
  );
}
