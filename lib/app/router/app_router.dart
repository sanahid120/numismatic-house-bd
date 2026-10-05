import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numismatic_house_bd/admin/auctions/screens/manage_auctions.dart';
import 'package:numismatic_house_bd/admin/dashboard/screens/admin_dashboard.dart';
import 'package:numismatic_house_bd/admin/products/screens/manage_products.dart';
import 'package:numismatic_house_bd/admin/profiles/screens/admin_profile.dart';
import 'package:numismatic_house_bd/app/router/route_names.dart';
import 'package:numismatic_house_bd/app/router/route_paths.dart';
import 'package:numismatic_house_bd/auth/presentation/screens/signin_screen.dart';
import 'package:numismatic_house_bd/auth/presentation/screens/signup_screen.dart';
import 'package:numismatic_house_bd/pages/Home/screens/home.dart';
import 'package:numismatic_house_bd/pages/auction/screens/auctions.dart';
import 'package:numismatic_house_bd/pages/profiles/screens/user_profile.dart';
import 'package:numismatic_house_bd/pages/shop/sceens/shop_screen.dart';
import 'package:numismatic_house_bd/shared/screens/product_details/product_details_screen.dart';
import '../app_colors.dart';

final appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      name: RouteNames.home,
      path: RoutePaths.home,
      builder: (context, state) => const Homepage(),
    ),
    GoRoute(
      name: RouteNames.shop,
      path: RoutePaths.shop,
      builder: (context, state) => const ShopScreen(),
    ),
    GoRoute(
      name: RouteNames.auction,
      path: RoutePaths.auction,
      builder: (context, state) => const AuctionsScreen(),
    ),
    GoRoute(
      name: RouteNames.productDetails,
      path: '/products/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      name: RouteNames.contact,
      path: RoutePaths.contact,
      builder: (context, state) => const Homepage(), // Mapping to Home for now
    ),

    // Auth Routes
    GoRoute(
      name: RouteNames.signIn,
      path: RoutePaths.signIn,
      builder: (context, state) => const SigninScreen(),
    ),
    GoRoute(
      name: RouteNames.signUp,
      path: RoutePaths.signUp,
      builder: (context, state) => const SignupScreen(),
    ),

    // Profile Routes
    GoRoute(
      name: RouteNames.profile,
      path: RoutePaths.profile,
      builder: (context, state) => const UserProfileScreen(),
    ),

    // Admin Routes
    GoRoute(
      name: RouteNames.adminDashboard,
      path: RoutePaths.adminDashboard,
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      name: RouteNames.adminProducts,
      path: RoutePaths.adminProducts,
      builder: (context, state) => const ManageProductsScreen(),
    ),
    GoRoute(
      name: RouteNames.adminAuctions,
      path: RoutePaths.adminAuctions,
      builder: (context, state) => const ManageAuctionsScreen(),
    ),
    GoRoute(
      name: RouteNames.adminProfile,
      path: RoutePaths.adminProfile,
      builder: (context, state) => const AdminProfileScreen(),
    ),
  ],
  errorBuilder: (context, state) => ErrorPage(path: state.uri.path),
);

class ErrorPage extends StatelessWidget {
  const ErrorPage({required this.path, super.key});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: AppColors.clay),
            const SizedBox(height: 20),
            Text(
              '404 - Page Not Found',
              style: TextStyle(
                color: AppColors.forestDeep,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'We couldn\'t find the path: $path',
              style: const TextStyle(color: AppColors.mutedInk),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Return to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
