import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../features/catalog/presentation/widgets/catalog_product_grid.dart';
import 'section_header_with_action.dart';

class DesktopView extends StatelessWidget {
  const DesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SectionHeaderWithAction(
            title: 'Popular Products',
            subtitle: 'Featured Collectibles',
            onSeeAllTap: () => context.go(RoutePaths.shop),
          ),
          const SizedBox(height: 40),
          const CatalogProductGrid(columns: 4, aspectRatio: 0.75, maxItems: 8),
        ],
      ),
    );
  }
}
