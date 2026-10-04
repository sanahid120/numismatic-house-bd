import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../shop/widgets/shop_sidebar.dart';
import '../models/auction_product.dart';
import '../widgets/auction_card.dart';

class DesktopAuctionView extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const DesktopAuctionView({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double horizontalPadding = constraints.maxWidth > 1400 ? 60 : 30;
        double sidebarWidth = constraints.maxWidth > 1200 ? 300 : 260;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              SizedBox(
                width: sidebarWidth,
                child: ShopSidebar(
                  onCategorySelected: onCategorySelected,
                  onSearch: (query) {},
                ),
              ),
              SizedBox(width: constraints.maxWidth > 1200 ? 40 : 20),
              // Content Area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(constraints.maxWidth),
                    const SizedBox(height: 30),
                    _buildAuctionGrid(constraints.maxWidth),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(double width) {
    return Column(
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
        Text(
          'Live Auctions',
          style: TextStyle(
            color: AppColors.forestDeep,
            fontSize: width > 1200 ? 32 : 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bid on the rarest numismatic treasures from across the globe.',
          style: TextStyle(color: AppColors.mutedInk, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildAuctionGrid(double width) {
    int crossAxisCount = width > 1100 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        childAspectRatio: 0.72,
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
