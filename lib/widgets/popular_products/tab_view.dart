import 'package:flutter/material.dart';
import 'product_card.dart';
import 'product_model.dart';
import 'section_header_with_action.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SectionHeaderWithAction(
            title: 'Popular Products',
            subtitle: 'Featured Collectibles',
            onSeeAllTap: () {},
          ),
          const SizedBox(height: 35),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.7,
            ),
            itemCount: popularProducts.length > 6 ? 6 : popularProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(product: popularProducts[index]);
            },
          ),
        ],
      ),
    );
  }
}
