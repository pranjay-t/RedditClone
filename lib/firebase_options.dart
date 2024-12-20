// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  static  FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['Firebase_Api_Key_web']!,
    appId: dotenv.env['Firebase_App_Id_web']!,
    messagingSenderId: dotenv.env['Firebase_MessageSenderId_web']!,
    projectId: dotenv.env['Firebase_projectId_web']!,
    authDomain: dotenv.env['Firebase_AuthDomain_web']!,
    storageBucket: dotenv.env['Firebase_StorageBucket_web']!,
  );

  static  FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['Firebase_Api_Key_android']!,
    appId: dotenv.env['Firebase_App_Id_android']!,
    messagingSenderId: dotenv.env['Firebase_MessageSenderId_android']!,
    projectId: dotenv.env['Firebase_ProjectId_android']!,
    storageBucket: dotenv.env['Firebase_StorageBucket_android']!,
  );

  static  FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['Firebase_Api_Key_ios']!,
    appId: dotenv.env['Firebase_App_Id_ios']!,
    messagingSenderId: dotenv.env['Firebase_MessageSenderId_ios']!,
    projectId: dotenv.env['Firebase_projectId_ios']!,
    storageBucket: dotenv.env['Firebase_StorageBucket_ios']!,
    iosBundleId: dotenv.env['Firebase_IosBundeleId_ios']!,
  );

  static  FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['Firebase_Api_Key_ios']!,
    appId: dotenv.env['Firebase_App_Id_ios']!,
    messagingSenderId: dotenv.env['Firebase_MessageSenderId_ios']!,
    projectId: dotenv.env['Firebase_projectId_ios']!,
    storageBucket: dotenv.env['Firebase_StorageBucket_ios']!,
    iosBundleId: dotenv.env['Firebase_IosBundeleId_ios']!,
  );

  static  FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['Firebase_Api_Key_windows']!,
    appId: dotenv.env['Firebase_App_Id_windows']!,
    messagingSenderId: dotenv.env['Firebase_MessageSenderId_windows']!,
    projectId: dotenv.env['Firebase_projectId_windows']!,
    authDomain: dotenv.env['Firebase_AuthDomain_windows']!,
    storageBucket: dotenv.env['Firebase_StorageBucket_windows']!,
  );
}