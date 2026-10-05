import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_paths.dart';
import '../../../../features/catalog/presentation/widgets/catalog_product_grid.dart';
import 'section_header_with_action.dart';

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SectionHeaderWithAction(
            title: 'Popular Products',
            subtitle: 'Featured',
            onSeeAllTap: () => context.go(RoutePaths.shop),
          ),
          const SizedBox(height: 25),
          const CatalogProductGrid(columns: 2, aspectRatio: 0.65, maxItems: 4),
        ],
      ),
    );
  }
}
