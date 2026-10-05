import 'package:flutter/material.dart';
import 'package:numismatic_house_bd/app/app_colors.dart';

import '../../../shared/widgets/navbar/navbar.dart';
import '../../../shared/widgets/navbar/site_drawer.dart';
import '../widgets/categories_section/categories_section.dart';
import '../widgets/footer/footer_section.dart';
import '../widgets/hero_section/hero_section.dart';
import '../widgets/popular_products/popular_products_section.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: Navbar(),
      drawer: const SiteDrawer(),
      body: SingleChildScrollView(
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
}
