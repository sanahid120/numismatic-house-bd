import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../Home/widgets/popular_products/product_card.dart';
import '../../Home/widgets/popular_products/product_model.dart';
import '../widgets/pagination_widget.dart';

class MobileShopView extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final int currentPage;
  final Function(int) onPageChanged;

  const MobileShopView({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.currentPage,
    required this.onPageChanged,
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
                      child: const TextField(
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
                child: Row(
                  children: [
                    _buildCategoryChip('All', true),
                    _buildCategoryChip('Bangladesh', false),
                    _buildCategoryChip('Pakistan', false),
                    _buildCategoryChip('Foreign', false),
                    _buildCategoryChip('Rare', false),
                  ],
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
                    '${popularProducts.length} ITEMS FOUND',
                    style: const TextStyle(
                      color: AppColors.mutedInk,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                  const Text(
                    'SORT BY: NEWEST',
                    style: TextStyle(
                      color: AppColors.forestDeep,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildProductGrid(),
              const SizedBox(height: 40),
              PaginationWidget(
                currentPage: currentPage,
                totalPages: 5,
                onPageChanged: onPageChanged,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
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

  Widget _buildProductGrid() {
    return GridView.builder(
      key: const ValueKey('shop_mobile_grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.6,
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
