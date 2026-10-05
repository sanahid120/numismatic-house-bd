import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../features/auctions/models/auction.dart';
import '../../../features/auctions/presentation/widgets/auction_card.dart';

class MobileAuctionView extends StatelessWidget {
  final String selectedCategory;
  final List<AuctionProduct> products;

  const MobileAuctionView({
    super.key,
    required this.selectedCategory,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildAuctionGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedCategory.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.brass,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Text(
                'Live Auctions',
                style: TextStyle(
                  color: AppColors.forestDeep,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          icon: const Icon(Icons.filter_list, color: AppColors.forest),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.paper,
            padding: const EdgeInsets.all(12),
            elevation: 2,
            shadowColor: Colors.black12,
          ),
        ),
      ],
    );
  }

  Widget _buildAuctionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return AuctionCard(
          product: product,
          onTap: () => context.push('${RoutePaths.auction}/${product.id}'),
        );
      },
    );
  }
}
