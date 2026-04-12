import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static bool get isSupportedPlatform {
    if (kIsWeb) {
      return false;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web in this project.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB65ikfPeNkZGTeKVRwUJ69glG71j4vzQs',
    appId: '1:717917226408:android:9f44201e210857fea3099d',
    messagingSenderId: '717917226408',
    projectId: 'food-rescue-1f088',
    storageBucket: 'food-rescue-1f088.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBi1szZUpkhdLPoaGAtUYBDOyxAPQHqAuk',
    appId: '1:717917226408:ios:ef5be493255c7c55a3099d',
    messagingSenderId: '717917226408',
    projectId: 'food-rescue-1f088',
    storageBucket: 'food-rescue-1f088.firebasestorage.app',
    iosBundleId: 'com.khian.foodrescuenetwork',
  );
}
