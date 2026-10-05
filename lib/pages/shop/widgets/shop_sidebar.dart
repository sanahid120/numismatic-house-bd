import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../features/catalog/providers/catalog_provider.dart';

class ShopSidebar extends StatelessWidget {
  final Function(String) onCategorySelected;
  final Function(String) onSearch;
  final String selectedCategory;

  const ShopSidebar({
    super.key,
    required this.onCategorySelected,
    required this.onSearch,
    this.selectedCategory = 'All Collection',
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SEARCH',
            style: TextStyle(
              color: AppColors.brass,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: 'Search notes...',
              prefixIcon: const Icon(Icons.search, color: AppColors.forest),
              filled: true,
              fillColor: AppColors.canvas,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'CATEGORIES',
            style: TextStyle(
              color: AppColors.brass,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<List<String>>(
            stream: context.read<CatalogProvider>().watchActiveCategories(),
            builder: (context, snapshot) {
              final names = <String>{
                'All Collection',
                ...(snapshot.data ?? const <String>[]),
                'Rare & Antique',
                'UNC Sets',
              };
              return Column(
                children: names
                    .map((name) => _buildCategoryItem(name, name == selectedCategory))
                    .toList(),
              );
            },
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCategoryItem(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => onCategorySelected(title),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.forest : AppColors.ink,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
            if (isSelected)
              const Icon(Icons.chevron_right, size: 18, color: AppColors.forest),
          ],
        ),
      ),
    );
  }
}
