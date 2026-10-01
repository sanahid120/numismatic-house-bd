import 'package:flutter/material.dart';

import '../pages/Home/screens/home.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Numismatic House-BD',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}