import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import '../features/catalog/data/catalog_repository.dart';
import '../features/catalog/providers/catalog_provider.dart';
import '../features/auctions/data/auction_repository.dart';
import '../features/auctions/providers/auction_provider.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        Provider(create: (_) => CatalogProvider(CatalogRepository())),
        Provider(create: (_) => AuctionProvider(AuctionRepository())),
      ],
      child: Builder(
        builder: (context) {
          final auth = context.read<AuthProvider>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Numismatic House-BD',
            theme: AppTheme.light,
            routerConfig: createAppRouter(auth),
          );
        },
      ),
    );
  }
}
