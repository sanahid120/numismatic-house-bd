import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
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
                      const Text(
                        'Dashboard Overview',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestDeep,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Stats Grid - Only Products and Auctions
                      _buildStatsGrid(sizingInformation),
                      const SizedBox(height: 40),
                      
                      if (!sizingInformation.isMobile)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: _buildEngagementSection()),
                            const SizedBox(width: 30),
                            Expanded(flex: 1, child: _buildRecentActivity()),
                          ],
                        )
                      else ...[
                        _buildEngagementSection(),
                        const SizedBox(height: 30),
                        _buildRecentActivity(),
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

  Widget _buildEngagementSection() {
    return Container(
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
            child: const Text('Chart Visualization Placeholder', style: TextStyle(color: AppColors.mutedInk)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
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
          const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.forestDeep)),
          const SizedBox(height: 20),
          _buildActivityItem('New Auction Started', '2 mins ago', Icons.gavel, Colors.red),
          _buildActivityItem('Product Updated', '45 mins ago', Icons.edit, Colors.blue),
          _buildActivityItem('New Note Added', '2 hours ago', Icons.add_circle_outline, Colors.green),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                Text(time, style: const TextStyle(color: AppColors.mutedInk, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
