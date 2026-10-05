import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/app_colors.dart';
import '../../../app/router/route_paths.dart';
import '../../../features/auctions/models/auction.dart';
import '../../../features/auctions/presentation/widgets/auction_card.dart';

class TabAuctionView extends StatelessWidget {
  final String selectedCategory;
  final List<AuctionProduct> products;

  const TabAuctionView({
    super.key,
    required this.selectedCategory,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 30),
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
                  letterSpacing: 1.5,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Live Auctions',
                style: TextStyle(
                  color: AppColors.forestDeep,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => Scaffold.of(context).openEndDrawer(),
          icon: const Icon(Icons.filter_list),
          label: const Text('Filters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.forest,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.68,
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
