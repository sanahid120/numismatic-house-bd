import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import 'category_model.dart';

class CategoryCard extends StatefulWidget {
  final CategoryData category;
  const CategoryCard({super.key, required this.category});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: AppColors.forest.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedScale(
                  scale: _isHovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Image.network(
                    widget.category.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.forestDeep.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 25,
                right: 25,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category.itemCount,
                      style: const TextStyle(
                          color: AppColors.brass,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.category.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
