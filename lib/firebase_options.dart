// Android options derived from android/app/google-services.json.
// Add platform-specific options with FlutterFire when registering iOS/Web.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError('Firebase is configured for Android only.');
  }

  static const android = FirebaseOptions(
    apiKey: 'AIzaSyCdDaTXvTSS5zFInJ-i8pcs5umJvCTeYOY',
    appId: '1:199146733315:android:c03f88bcdb527d64f83336',
    messagingSenderId: '199146733315',
    projectId: 'gado-hr',
    storageBucket: 'gado-hr.firebasestorage.app',
  );
}
