import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../features/catalog/presentation/widgets/catalog_product_grid.dart';

class TabShopView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final int currentPage;
  final Function(int) onPageChanged;

  const TabShopView({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabHeader(context),
          const SizedBox(height: 30),
          _buildProductGrid(),
        ],
      ),
    );
  }

  Widget _buildTabHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
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
              const Text(
                'Premium Collection',
                style: TextStyle(
                  color: AppColors.forestDeep,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          icon: const Icon(Icons.filter_list),
          label: const Text('Filters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forest,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return CatalogProductGrid(
      columns: 3,
      aspectRatio: 0.68,
      searchQuery: searchQuery,
      category: selectedCategory,
      page: currentPage,
      onPageChanged: onPageChanged,
    );
  }
}
