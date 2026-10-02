import 'package:flutter/material.dart';
import 'category_card.dart';
import 'category_model.dart';
import 'section_header.dart';

class TabView extends StatelessWidget {
  const TabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Categories',
            subtitle: 'Explore Our Collections',
          ),
          const SizedBox(height: 35),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              childAspectRatio: 1.2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryCard(category: categories[index]);
            },
          ),
        ],
      ),
    );
  }
}
