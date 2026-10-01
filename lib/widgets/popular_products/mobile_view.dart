import 'package:flutter/material.dart';
import 'product_card.dart';
import 'product_model.dart';
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
            onSeeAllTap: () {},
          ),
          const SizedBox(height: 25),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.65,
            ),
            itemCount: 4, // Show only 4 items on mobile to keep it clean
            itemBuilder: (context, index) {
              return ProductCard(product: popularProducts[index]);
            },
          ),
        ],
      ),
    );
  }
}
