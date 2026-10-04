import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/router/route_names.dart';
import 'product_model.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.brass.withOpacity(0.5)
                : AppColors.line.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withOpacity(_isHovered ? 0.12 : 0.05),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 12 : 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap ?? () {
                context.pushNamed(
                  RouteNames.productDetails,
                  pathParameters: {'id': widget.product.id},
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image & Badge Section
                  Expanded(
                    flex: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.mint.withOpacity(0.2),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.forest),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.mint.withOpacity(0.2),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.mutedInk,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.forestDeep.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.product.condition.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                        if (widget.product.isAuction)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.clay,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.gavel_rounded, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'AUCTION',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Product Info Section
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.mutedInk,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.forestDeep,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '৳${widget.product.price}',
                              style: const TextStyle(
                                color: AppColors.clay,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (widget.product.originalPrice != null &&
                                widget.product.originalPrice! > widget.product.price) ...[
                              const SizedBox(width: 8),
                              Text(
                                '৳${widget.product.originalPrice}',
                                style: TextStyle(
                                  color: AppColors.mutedInk.withOpacity(0.6),
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
