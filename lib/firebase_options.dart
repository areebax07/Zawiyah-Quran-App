import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ANDROID CONFIGURATION - EXACT VALUES FROM YOUR google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSZ7qADzFyUCHRcQTcBb_k9C4G-3DICXk', // ← From "current_key"
    appId: '1:1068497114270:android:9753696ecd1a04a26c978f', // ← From "mobilesdk_app_id"
    messagingSenderId: '1068497114270', // ← From "project_number"
    projectId: 'zawiyah-8cee6', // ← From "project_id"
    storageBucket: 'zawiyah-8cee6.firebasestorage.app', // ← From "storage_bucket"
    authDomain: 'zawiyah-8cee6.firebaseapp.com',
      databaseURL: 'https://zawiyah-8cee6.firebaseio.com'
  );

  // IOS CONFIGURATION (use same values for now)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSZ7qADzFyUCHRcQTcBb_k9C4G-3DICXk',
    appId: '1:1068497114270:android:9753696ecd1a04a26c978f',
    messagingSenderId: '1068497114270',
    projectId: 'zawiyah-8cee6',
    storageBucket: 'zawiyah-8cee6.firebasestorage.app',
    authDomain: 'zawiyah-8cee6.firebaseapp.com',
    databaseURL: 'https://zawiyah-8cee6.firebaseio.com',
    iosBundleId: 'com.example.zawiyah',
  );
}