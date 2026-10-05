import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../models/auction.dart';
import 'auction_timer.dart';

class AuctionCard extends StatefulWidget {
  final AuctionProduct product;
  final VoidCallback? onTap;

  const AuctionCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<AuctionCard> createState() => _AuctionCardState();
}

class _AuctionCardState extends State<AuctionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                          child: const Icon(Icons.image_not_supported_outlined, color: AppColors.mutedInk),
                        ),
                      ),
                      
                      // Live Badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.clay,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            children: [
                              CircleAvatar(radius: 3, backgroundColor: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Info Section
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Condition
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.category.toUpperCase(),
                          style: const TextStyle(color: AppColors.mutedInk, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1),
                        ),
                        Text(
                          widget.product.condition,
                          style: const TextStyle(color: AppColors.forest, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      widget.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.forestDeep, fontSize: 14, fontWeight: FontWeight.bold, height: 1.25),
                    ),
                    const SizedBox(height: 12),
                    // Current Bid
                    const Text('CURRENT BID', style: TextStyle(color: AppColors.mutedInk, fontSize: 8, fontWeight: FontWeight.bold)),
                    Text(
                      '৳${widget.product.currentBid}',
                      style: const TextStyle(color: AppColors.forestDeep, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    // Timer
                    AuctionTimer(endTime: widget.product.endTime),
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
