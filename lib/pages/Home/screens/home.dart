import 'package:flutter/material.dart';
import 'package:numismatic_house_bd/app/app_colors.dart';

import '../widgets/categories_section/categories_section.dart';
import '../widgets/footer/footer_section.dart';
import '../widgets/hero_section/hero_section.dart';
import '../widgets/navbar/navbar.dart';
import '../widgets/popular_products/popular_products_section.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const Navbar(),
      endDrawer: Drawer(
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
            _buildDrawerItem(Icons.home, 'Home', () {}),
            _buildDrawerItem(Icons.shopping_bag, 'Shop', () {}),
            _buildDrawerItem(Icons.category, 'Categories', () {}),
            _buildDrawerItem(Icons.info, 'About', () {}),
            _buildDrawerItem(Icons.contact_mail, 'Contact', () {}),
            const Divider(),
            _buildDrawerItem(Icons.person, 'Profile', () {}),
            _buildDrawerItem(Icons.shopping_cart, 'Cart', () {}),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            SizedBox(height: 60),
            CategoriesSection(),
            SizedBox(height: 80),
            PopularProductsSection(),
            SizedBox(height: 80),
            FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.forest),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
