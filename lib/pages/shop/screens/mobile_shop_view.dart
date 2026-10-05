import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../features/catalog/presentation/widgets/catalog_product_grid.dart';
import '../../../features/catalog/providers/catalog_provider.dart';

class MobileShopView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final int currentPage;
  final Function(int) onPageChanged;
  final Function(String) onSearch;
  final Function(String) onCategorySelected;

  const MobileShopView({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.currentPage,
    required this.onPageChanged,
    required this.onSearch,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- Premium Search & Filter Bar ---
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        onChanged: onSearch,
                        decoration: InputDecoration(
                          hintText: 'Search rare notes...',
                          prefixIcon: Icon(Icons.search, color: AppColors.forest),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.tune, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.forest,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // --- Horizontal Categories ---
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<List<String>>(
                    stream: context.read<CatalogProvider>().watchActiveCategories(),
                    builder: (context, snapshot) {
                      final labels = ['All Collection', ...(snapshot.data ?? const <String>[])];
                      return Row(
                        children: labels.map((label) => _buildCategoryChip(label)).toList(),
                      );
                    },
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                  'CURATED COLLECTIBLES',
                    style: const TextStyle(
                      color: AppColors.mutedInk,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  if (selectedCategory != 'All Collection')
                    Text(
                      selectedCategory,
                      style: const TextStyle(color: AppColors.forestDeep, fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              CatalogProductGrid(
                columns: 2,
                aspectRatio: 0.6,
                searchQuery: searchQuery,
                category: selectedCategory,
                page: currentPage,
                onPageChanged: onPageChanged,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = selectedCategory == label ||
        (label == 'All Collection' && selectedCategory.toLowerCase().startsWith('all'));
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ActionChip(
        onPressed: () => onCategorySelected(label),
        label: Text(label),
        backgroundColor: isSelected ? AppColors.forest : AppColors.canvas,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.forestDeep,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
    );
}
}
