import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';

class SiteDrawer extends StatelessWidget {
  const SiteDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.paper,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.forest,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance, color: AppColors.forest, size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  'NUMISMATIC HOUSE BD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.home, 'Home', RoutePaths.home),
          _buildDrawerItem(context, Icons.shopping_bag, 'Shop', RoutePaths.shop),
          _buildDrawerItem(context, Icons.gavel, 'Auction', RoutePaths.auction),
          _buildDrawerItem(context, Icons.contact_mail, 'Contact', RoutePaths.contact),
          const Divider(),
          _buildDrawerItem(context, Icons.person, 'Profile', RoutePaths.profile),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String path) {
    return ListTile(
      leading: Icon(icon, color: AppColors.forest),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (path != '#') {
          context.go(path);
        }
      },
    );
  }
}
