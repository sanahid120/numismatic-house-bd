import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../widgets/admin_sidebar.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        bool isMobile = sizingInformation.isMobile || sizingInformation.isTablet;

        return Scaffold(
          backgroundColor: AppColors.canvas,
          appBar: isMobile
              ? AppBar(
                  backgroundColor: AppColors.forestDeep,
                  title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
                  iconTheme: const IconThemeData(color: Colors.white),
                )
              : null,
          drawer: isMobile ? const AdminSidebar(currentRoute: RoutePaths.adminDashboard) : null,
          body: Row(
            children: [
              if (!isMobile)
                const SizedBox(
                  width: 280,
                  child: AdminSidebar(currentRoute: RoutePaths.adminDashboard),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 30),
                      // Stats Grid
                      _buildStatsGrid(sizingInformation),
                      const SizedBox(height: 40),
                      
                      // Responsive Content: Engagement and Admin Quick Info
                      if (!sizingInformation.isMobile)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildEngagementSection()),
                            const SizedBox(width: 30),
                            Expanded(flex: 1, child: _buildAdminQuickProfile(context)),
                          ],
                        )
                      else ...[
                        _buildAdminQuickProfile(context),
                        const SizedBox(height: 30),
                        _buildEngagementSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Dashboard Overview',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.forestDeep,
      ),
    );
  }

  Widget _buildStatsGrid(SizingInformation sizingInformation) {
    int crossAxisCount = sizingInformation.isMobile ? 1 : 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      shrinkWrap: true,
      childAspectRatio: sizingInformation.isMobile ? 2.5 : 4,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Total Products', '458', Icons.inventory_2_outlined, Colors.orange),
        _buildStatCard('Live Auctions', '12', Icons.gavel_outlined, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(color: AppColors.mutedInk, fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.forestDeep)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminQuickProfile(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.mint,
                child: Icon(Icons.admin_panel_settings, size: 40, color: AppColors.forest),
              ),
              const SizedBox(height: 15),
              Text(
                '${auth.userData?['firstName'] ?? 'Admin'} ${auth.userData?['lastName'] ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text('Administrator', style: TextStyle(color: AppColors.brass, fontSize: 12)),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              _buildQuickLink(Icons.person_outline, 'Profile Settings', () {
                // Navigate to profile
              }),
              _buildQuickLink(Icons.logout, 'Sign Out', () async {
                await auth.signOut();
              }, isDestructive: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickLink(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: isDestructive ? Colors.redAccent : AppColors.forest),
      title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : AppColors.forestDeep)),
    );
  }

  Widget _buildEngagementSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('User Engagement (Last 7 Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forestDeep)),
          const SizedBox(height: 40),
          Container(
            height: 300,
            alignment: Alignment.center,
            child: const Text('Chart Statistics Visualization Placeholder', style: TextStyle(color: AppColors.mutedInk)),
          ),
        ],
      ),
    );
  }
}
