import 'package:flutter/material.dart';

import 'app/porto_certo_app.dart';
import 'core/services/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  runApp(const PortoCertoApp());
}
