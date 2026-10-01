import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numismatic_house_bd/app/router/route_names.dart';
import 'package:numismatic_house_bd/app/router/route_paths.dart';
import 'package:numismatic_house_bd/pages/Home/screens/home.dart';
final appRouter = GoRouter(
  routes: [
    GoRoute(
      name: RouteNames.home,
      path: RoutePaths.home,
      builder: (_, _) => const Homepage(),
    ),

    // GoRoute(
    //   name: RouteNames.productDetails,
    //   path: RoutePaths.productDetails,
    //   builder: (_, state) =>
    //       ProductDetailsPage(slug: state.pathParameters['slug']!),
    // ),
  ],
  errorBuilder: (_, state) => ErrorPage(path: state.uri.path),
);

class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) =>
      Center(child: Text('Page not found: $path'));
}
