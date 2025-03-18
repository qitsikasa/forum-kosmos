// filepath: e:\Flutter\forum\lib\firebase_options.dart
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
    apiKey: 'AIzaSyBPqlSj_Al1ZkQTuJx8xDkGP_W0-IYdquI',
    appId: '1:931598589654:web:28431faeb4be81ee30f377',
    messagingSenderId: '931598589654',
    projectId: 'forum-test-a2e3b',
    authDomain: 'forum-test-a2e3b.firebaseapp.com',
    storageBucket: 'forum-test-a2e3b.firebasestorage.app',
    measurementId: 'G-5TLXE2NCGZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAScriV4AdNG1ocY6M3FYMWEwBaPE-EcGw',
    appId: '1:931598589654:android:17f5ccc6e6bbc69730f377',
    messagingSenderId: '931598589654',
    projectId: 'forum-test-a2e3b',
    storageBucket: 'forum-test-a2e3b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-XypQ4upoUeMRdQcv4bxPNmjXJ_tP380',
    appId: '1:931598589654:ios:4ca7b89da95407c230f377',
    messagingSenderId: '931598589654',
    projectId: 'forum-test-a2e3b',
    storageBucket: 'forum-test-a2e3b.firebasestorage.app',
    iosBundleId: 'com.example.forum',
  );
}