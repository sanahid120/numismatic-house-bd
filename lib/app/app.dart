import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Numismatic House-BD',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF1E5B49), // Forest Green
        ),
        routerConfig: appRouter,
      ),
    );
  }
}