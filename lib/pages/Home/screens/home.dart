import 'package:flutter/material.dart';
import 'package:numismatic_house_bd/app/app_colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../widgets/hero_section/hero_section.dart';
import '../../../widgets/navbar/navbar.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            const SizedBox(height: 60),
            
            // --- CATEGORIES SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(
                    title: 'Categories',
                    subtitle: 'Explore Our Collections',
                  ),
                  const SizedBox(height: 40),
                  
                  ResponsiveBuilder(
                    builder: (context, sizingInformation) {
                      int crossAxisCount = 3;
                      if (sizingInformation.isMobile) crossAxisCount = 1;
                      else if (sizingInformation.isTablet) crossAxisCount = 2;
                      
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 30,
                          childAspectRatio: sizingInformation.isMobile ? 1.5 : 1.1,
                        ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return _CategoryCard(category: _categories[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: AppColors.brass,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 3, width: 50, color: AppColors.forest),
        const SizedBox(height: 15),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.forestDeep,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _CategoryData {
  final String title;
  final String imageUrl;
  final String itemCount;

  _CategoryData(this.title, this.imageUrl, this.itemCount);
}

final List<_CategoryData> _categories = [
  _CategoryData('Bangladeshi Notes', 'https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=600&fit=crop', '120+ Items'),
  _CategoryData('Pakistani Notes', 'https://images.unsplash.com/photo-1599059813005-11265ba4b4ce?q=80&w=400&fit=crop', '85+ Items'),
  _CategoryData('Foreign Notes', 'https://images.unsplash.com/photo-1502920514313-52581002a659?q=80&w=600&fit=crop', '240+ Items'),
];

class _CategoryCard extends StatefulWidget {
  final _CategoryData category;
  const _CategoryCard({required this.category});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.forest.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Image.network(
                    widget.category.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.forestDeep.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                right: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.itemCount,
                      style: const TextStyle(color: AppColors.brass, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.category.title,
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
