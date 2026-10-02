import 'package:flutter/material.dart';
import 'product_card.dart';
import 'product_model.dart';
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
            onSeeAllTap: () {},
          ),
          const SizedBox(height: 40),
          GridView.builder(
            key: const ValueKey('popular_products_desktop_grid'),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              childAspectRatio: 0.75,
            ),
            itemCount: popularProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                key: ValueKey('desktop_product_${popularProducts[index].name}_$index'),
                product: popularProducts[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
