import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numismatic_house_bd/auth/providers/auth_provider.dart';
import 'package:numismatic_house_bd/admin/auctions/screens/manage_auctions.dart';
import 'package:numismatic_house_bd/admin/categories/screens/manage_categories.dart';
import 'package:numismatic_house_bd/admin/dashboard/screens/admin_dashboard.dart';
import 'package:numismatic_house_bd/admin/products/screens/manage_products.dart';
import 'package:numismatic_house_bd/admin/profiles/screens/admin_profile.dart';
import 'package:numismatic_house_bd/app/router/route_names.dart';
import 'package:numismatic_house_bd/app/router/route_paths.dart';
import 'package:numismatic_house_bd/auth/presentation/screens/signin_screen.dart';
import 'package:numismatic_house_bd/auth/presentation/screens/signup_screen.dart';
import 'package:numismatic_house_bd/pages/Home/screens/home.dart';
import 'package:numismatic_house_bd/pages/auction/screens/auctions.dart';
import 'package:numismatic_house_bd/pages/auction/screens/auction_details_screen.dart';
import 'package:numismatic_house_bd/features/contact/presentation/screens/contact_screen.dart';
import 'package:numismatic_house_bd/pages/profiles/screens/user_profile.dart';
import 'package:numismatic_house_bd/pages/shop/screens/shop_screen.dart';
import 'package:numismatic_house_bd/shared/screens/product_details/product_details_screen.dart';
import '../app_colors.dart';

GoRouter createAppRouter(AuthProvider auth) => GoRouter(
  initialLocation: RoutePaths.home,
  refreshListenable: auth,
  redirect: (context, state) async {
    final location = state.uri.path;
    final isAdminRoute = location == RoutePaths.adminDashboard ||
        location.startsWith('${RoutePaths.adminDashboard}/');
    final isProfileRoute = location == RoutePaths.profile ||
        location == RoutePaths.adminProfile;
    final isAuthRoute = location == RoutePaths.signIn ||
        location == RoutePaths.signUp;
    final user = auth.currentUser;

    if (isAdminRoute && user == null) {
      return '${RoutePaths.signIn}?from=${Uri.encodeComponent(location)}';
    }
    if ((isAdminRoute || isProfileRoute) &&
        user != null &&
        !user.emailVerified) {
      return RoutePaths.signIn;
    }
    if (isProfileRoute && user == null) {
      return '${RoutePaths.signIn}?from=${Uri.encodeComponent(location)}';
    }
    if (isAdminRoute && user != null) {
      if (!auth.profileLoaded) await auth.profileReady;
      if (!auth.isAdmin) return RoutePaths.home;
    }
    if (isAuthRoute && user != null && user.emailVerified) {
      if (!auth.profileLoaded) await auth.profileReady;
      return auth.isAdmin ? RoutePaths.adminDashboard : RoutePaths.home;
    }
    return null;
  },
  routes: [
    GoRoute(
      name: RouteNames.home,
      path: RoutePaths.home,
      builder: (context, state) => const Homepage(),
    ),
    GoRoute(
      name: RouteNames.shop,
      path: RoutePaths.shop,
      builder: (context, state) => ShopScreen(
        initialCategory: state.uri.queryParameters['category'] ?? 'All Collection',
      ),
    ),
    GoRoute(
      name: RouteNames.auction,
      path: RoutePaths.auction,
      builder: (context, state) => const AuctionsScreen(),
    ),
    GoRoute(
      name: RouteNames.auctionDetails,
      path: RoutePaths.auctionDetails,
      builder: (context, state) => AuctionDetailsScreen(
        auctionId: state.pathParameters['id']!,
      ),
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
      builder: (context, state) => const ContactScreen(),
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
      name: RouteNames.adminCategories,
      path: RoutePaths.adminCategories,
      builder: (context, state) => const ManageCategoriesScreen(),
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
