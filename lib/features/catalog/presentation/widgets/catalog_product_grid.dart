import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app/app_colors.dart';
import '../../models/product.dart';
import '../../providers/catalog_provider.dart';
import 'product_card.dart';

class CatalogProductGrid extends StatelessWidget {
  const CatalogProductGrid({
    super.key,
    required this.columns,
    required this.aspectRatio,
    this.searchQuery = '',
    this.category = 'All Collection',
    this.page = 1,
    this.onPageChanged,
    this.pageSize = 12,
    this.maxItems,
  });

  final int columns;
  final double aspectRatio;
  final String searchQuery;
  final String category;
  final int page;
  final ValueChanged<int>? onPageChanged;
  final int pageSize;
  final int? maxItems;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Product>>(
    stream: context.read<CatalogProvider>().watchPublishedProducts(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const _CatalogMessage(
          icon: Icons.wifi_off_outlined,
          title: 'Catalog is temporarily unavailable',
          detail: 'Please check your connection and try again.',
        );
      }
      if (!snapshot.hasData) {
        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator(color: AppColors.forest)),
        );
      }

      final items = snapshot.data!.where(_matches).toList(growable: false);
      if (items.isEmpty) {
        return const _CatalogMessage(
          icon: Icons.inventory_2_outlined,
          title: 'No products found',
          detail: 'Try a different search or category.',
        );
      }

      final visible = maxItems == null
          ? items.skip((page > 1 ? page - 1 : 0) * pageSize).take(pageSize).toList()
          : items.take(maxItems!).toList();
      final totalPages = ((items.length - 1) ~/ pageSize) + 1;
      return Column(children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: aspectRatio,
          ),
          itemCount: visible.length,
          itemBuilder: (context, index) => ProductCard(product: visible[index]),
        ),
        if (onPageChanged != null && totalPages > 1) ...[
          const SizedBox(height: 32),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              onPressed: page > 1 ? () => onPageChanged!(page - 1) : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text('$page / $totalPages', style: const TextStyle(color: AppColors.mutedInk)),
            IconButton(
              onPressed: page < totalPages ? () => onPageChanged!(page + 1) : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ]),
        ],
      ]);
    },
  );

  bool _matches(Product product) {
    final query = searchQuery.trim().toLowerCase();
    final normalizedCategory = category
        .toLowerCase()
        .replaceAll(' notes', '')
        .replaceAll(' collection', '')
        .trim();
    final categoryMatches = normalizedCategory.isEmpty ||
        normalizedCategory == 'all' ||
        product.category.toLowerCase() == normalizedCategory ||
        (normalizedCategory == 'rare & antique' &&
            product.name.toLowerCase().contains('rare')) ||
        (normalizedCategory == 'unc sets' && product.condition.toUpperCase() == 'UNC');
    final textMatches = query.isEmpty ||
        product.name.toLowerCase().contains(query) ||
        product.category.toLowerCase().contains(query) ||
        product.condition.toLowerCase().contains(query);
    return categoryMatches && textMatches;
  }
}

class _CatalogMessage extends StatelessWidget {
  const _CatalogMessage({required this.icon, required this.title, required this.detail});
  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 36, color: AppColors.mutedInk),
      const SizedBox(height: 12),
      Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.forestDeep)),
      const SizedBox(height: 6),
      Text(detail, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.mutedInk)),
    ]),
  );
}
