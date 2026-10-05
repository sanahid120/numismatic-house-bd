import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:numismatic_house_bd/pages/Home/screens/home.dart';

import 'app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


