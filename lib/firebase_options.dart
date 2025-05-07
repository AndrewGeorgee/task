// File generated based on Firebase configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default FirebaseOptions for use with your Firebase apps.
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

  // Web configuration from your Firebase project
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0-y57m7G0qf9KwO7HO0m_PA7xNNWwQqs',
    appId: '1:1074846618872:web:35e3f20b42a0fea82a970d',
    messagingSenderId: '1074846618872',
    projectId: 'task-ecec7',
    authDomain: 'task-ecec7.firebaseapp.com',
    storageBucket: 'task-ecec7.firebasestorage.app',
    measurementId: 'G-DDRMC33S71',
  );

  // Android configuration - will need to be updated with actual values
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0-y57m7G0qf9KwO7HO0m_PA7xNNWwQqs',
    appId: '1:1074846618872:android:placeholder',
    messagingSenderId: '1074846618872',
    projectId: 'task-ecec7',
    storageBucket: 'task-ecec7.firebasestorage.app',
  );

  // iOS configuration - will need to be updated with actual values
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0-y57m7G0qf9KwO7HO0m_PA7xNNWwQqs',
    appId: '1:1074846618872:ios:placeholder',
    messagingSenderId: '1074846618872',
    projectId: 'task-ecec7',
    storageBucket: 'task-ecec7.firebasestorage.app',
    iosBundleId: 'com.example.taskManagerApp',
  );

  // macOS configuration - will need to be updated with actual values
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0-y57m7G0qf9KwO7HO0m_PA7xNNWwQqs',
    appId: '1:1074846618872:macos:placeholder',
    messagingSenderId: '1074846618872',
    projectId: 'task-ecec7',
    storageBucket: 'task-ecec7.firebasestorage.app',
    iosBundleId: 'com.example.taskManagerApp.RunnerTests',
  );
}
