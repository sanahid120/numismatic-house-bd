import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class ShopSidebar extends StatelessWidget {
  final Function(String) onCategorySelected;
  final Function(String) onSearch;

  const ShopSidebar({
    super.key,
    required this.onCategorySelected,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
          _buildCategoryItem('All Collection', true),
          _buildCategoryItem('Bangladeshi Notes', false),
          _buildCategoryItem('Pakistani Notes', false),
          _buildCategoryItem('Foreign Notes', false),
          _buildCategoryItem('Rare & Antique', false),
          _buildCategoryItem('UNC Sets', false),
          const SizedBox(height: 32),
          const Text(
            'PRICE RANGE',
            style: TextStyle(
              color: AppColors.brass,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          RangeSlider(
            values: const RangeValues(0, 10000),
            max: 10000,
            divisions: 10,
            activeColor: AppColors.forest,
            inactiveColor: AppColors.mint,
            labels: const RangeLabels('৳0', '৳10000'),
            onChanged: (values) {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('৳0', style: TextStyle(color: AppColors.mutedInk, fontSize: 12)),
              Text('৳10000+', style: TextStyle(color: AppColors.mutedInk, fontSize: 12)),
            ],
          ),
        ],
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
