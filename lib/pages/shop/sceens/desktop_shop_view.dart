import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../Home/widgets/popular_products/product_card.dart';
import '../../Home/widgets/popular_products/product_model.dart';
import '../widgets/pagination_widget.dart';
import '../widgets/shop_sidebar.dart';

class DesktopShopView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final int currentPage;
  final Function(String) onSearch;
  final Function(String) onCategorySelected;
  final Function(int) onPageChanged;

  const DesktopShopView({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.currentPage,
    required this.onSearch,
    required this.onCategorySelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust horizontal padding based on total width
        double horizontalPadding = constraints.maxWidth > 1400 ? 60 : 30;
        // Adjust sidebar width for smaller desktop screens
        double sidebarWidth = constraints.maxWidth > 1200 ? 300 : 260;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              SizedBox(
                width: sidebarWidth,
                child: ShopSidebar(
                  onCategorySelected: onCategorySelected,
                  onSearch: onSearch,
                ),
              ),
              SizedBox(width: constraints.maxWidth > 1200 ? 40 : 20),
              // Product Grid Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(constraints.maxWidth),
                    const SizedBox(height: 30),
                    _buildProductGrid(constraints.maxWidth),
                    const SizedBox(height: 60),
                    PaginationWidget(
                      currentPage: currentPage,
                      totalPages: 5,
                      onPageChanged: onPageChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedCategory.toUpperCase(),
              style: const TextStyle(
                color: AppColors.brass,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Premium Collection',
              style: TextStyle(
                color: AppColors.forestDeep,
                fontSize: width > 1200 ? 32 : 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        if (width > 1000)
          Text(
            'Showing 1–12 of 60 results',
            style: TextStyle(color: AppColors.mutedInk, fontSize: 14),
          ),
      ],
    );
  }

  Widget _buildProductGrid(double width) {
    // Dynamic column count: 3 for large desktop, 2 for smaller desktop
    int crossAxisCount = width > 1100 ? 3 : 2;

    return GridView.builder(
      key: const ValueKey('shop_desktop_grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        childAspectRatio: 0.72,
      ),
      itemCount: popularProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: popularProducts[index],
        );
      },
    );
  }
}
