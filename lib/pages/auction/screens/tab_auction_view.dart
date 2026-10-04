import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../models/auction_product.dart';
import '../widgets/auction_card.dart';

class TabAuctionView extends StatelessWidget {
  final String selectedCategory;

  const TabAuctionView({
    super.key,
    required this.selectedCategory,
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
