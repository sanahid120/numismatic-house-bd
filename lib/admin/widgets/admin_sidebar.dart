import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/app_colors.dart';
import '../../app/router/route_paths.dart';

class AdminSidebar extends StatelessWidget {
  final String currentRoute;
  const AdminSidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: AppColors.forestDeep,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.forestDeep),
            child: Center(
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
                    child: const Icon(Icons.admin_panel_settings, color: AppColors.forest, size: 30),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'ADMIN PANEL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSidebarItem(
            context,
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            path: RoutePaths.adminDashboard,
          ),
          _buildSidebarItem(
            context,
            icon: Icons.inventory_2_outlined,
            title: 'Manage Products',
            path: RoutePaths.adminProducts,
          ),
          _buildSidebarItem(
            context,
            icon: Icons.gavel_outlined,
            title: 'Manage Auctions',
            path: RoutePaths.adminAuctions,
          ),
          _buildSidebarItem(
            context,
            icon: Icons.person_outline,
            title: 'My Profile',
            path: RoutePaths.adminProfile,
          ),
          const Spacer(),
          const Divider(color: Colors.white12),
          _buildSidebarItem(
            context,
            icon: Icons.home_outlined,
            title: 'View Site',
            path: RoutePaths.home,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, {required IconData icon, required String title, required String path}) {
    final bool isSelected = currentRoute == path;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.brass : Colors.white70),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        if (!isSelected) context.go(path);
      },
    );
  }
}
