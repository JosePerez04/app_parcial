import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyAOZV0l2sXVld2gDRTPOM66aiqPHWF7JpM',
    appId: '1:832382792164:web:16c6a498005f8e4b2617f1',
    messagingSenderId: '832382792164',
    projectId: 'fikwir',
    authDomain: 'fikwir.firebaseapp.com',
    storageBucket: 'fikwir.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDZqq1dKWOR2I2uhjNX5g0hI1c3k_8jNkc',
    appId: '1:832382792164:android:550e19d5ddd521242617f1',
    messagingSenderId: '832382792164',
    projectId: 'fikwir',
    storageBucket: 'fikwir.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCjgHtSMGONpxllC0N4vYX7Tqq-ZQ4u0xA',
    appId: '1:832382792164:ios:0dc0f64a2bf3209c2617f1',
    messagingSenderId: '832382792164',
    projectId: 'fikwir',
    storageBucket: 'fikwir.firebasestorage.app',
    iosClientId: '832382792164-mtvjmle1644k5gp35pp382912tkarad1.apps.googleusercontent.com',
    iosBundleId: 'com.example.fikWir',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCjgHtSMGONpxllC0N4vYX7Tqq-ZQ4u0xA',
    appId: '1:832382792164:ios:0dc0f64a2bf3209c2617f1',
    messagingSenderId: '832382792164',
    projectId: 'fikwir',
    storageBucket: 'fikwir.firebasestorage.app',
    iosClientId: '832382792164-mtvjmle1644k5gp35pp382912tkarad1.apps.googleusercontent.com',
    iosBundleId: 'com.example.fikWir',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAOZV0l2sXVld2gDRTPOM66aiqPHWF7JpM',
    appId: '1:832382792164:web:950514e57e49ea472617f1',
    messagingSenderId: '832382792164',
    projectId: 'fikwir',
    authDomain: 'fikwir.firebaseapp.com',
    storageBucket: 'fikwir.firebasestorage.app',
  );
}
