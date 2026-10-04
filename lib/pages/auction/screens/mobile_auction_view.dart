import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../models/auction_product.dart';
import '../widgets/auction_card.dart';

class MobileAuctionView extends StatelessWidget {
  final String selectedCategory;

  const MobileAuctionView({
    super.key,
    required this.selectedCategory,
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
      itemCount: demoAuctions.length,
      itemBuilder: (context, index) {
        return AuctionCard(
          product: demoAuctions[index],
          onTap: () {
             // TODO: Navigate to Auction Details
          },
        );
      },
    );
  }
}
