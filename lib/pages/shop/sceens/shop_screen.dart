import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../app/app_colors.dart';
import '../../../shared/widgets/navbar/navbar.dart';
import '../../../shared/widgets/navbar/site_drawer.dart';
import '../../Home/widgets/footer/footer_section.dart';
import '../widgets/shop_sidebar.dart';
import 'desktop_shop_view.dart';
import 'mobile_shop_view.dart';
import 'tab_shop_view.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All Collection';
  int _currentPage = 1;

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _currentPage = 1;
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: const Navbar(),
          drawer: const SiteDrawer(), // Shared site navigation
          endDrawer: sizingInformation.isDesktop
              ? null
              : Drawer(
                  width: sizingInformation.isMobile
                      ? MediaQuery.of(context).size.width * 0.85
                      : 400,
                  child: SafeArea(
                    child: ShopSidebar(
                      onCategorySelected: (cat) {
                        _onCategorySelected(cat);
                        Navigator.pop(context);
                      },
                      onSearch: _onSearch,
                    ),
                  ),
                ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ScreenTypeLayout.builder(
                  mobile: (context) => MobileShopView(
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    currentPage: _currentPage,
                    onPageChanged: _onPageChanged,
                  ),
                  tablet: (context) => TabShopView(
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    currentPage: _currentPage,
                    onPageChanged: _onPageChanged,
                  ),
                  desktop: (context) => DesktopShopView(
                    searchQuery: _searchQuery,
                    selectedCategory: _selectedCategory,
                    currentPage: _currentPage,
                    onSearch: _onSearch,
                    onCategorySelected: _onCategorySelected,
                    onPageChanged: _onPageChanged,
                  ),
                ),
                const FooterSection(),
              ],
            ),
          ),
        );
      },
    );
  }
}
