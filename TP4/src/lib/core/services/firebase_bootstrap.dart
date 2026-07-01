import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseBootstrap {
  static bool _initialized = false;

  static bool get initialized => _initialized;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _initialized = true;
    } catch (error, stackTrace) {
      _initialized = false;
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'porto_certo.firebase',
          context: ErrorDescription('while initializing Firebase'),
        ),
      );
    }
  }
}
