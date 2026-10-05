import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/app_colors.dart';
import '../../../app/config/app_config.dart';
import '../../../features/auctions/providers/auction_provider.dart';
import '../../../shared/widgets/navbar/navbar.dart';
import '../../../features/auctions/models/auction.dart';
import '../../../features/auctions/presentation/widgets/auction_timer.dart';

class AuctionDetailsScreen extends StatelessWidget {
  const AuctionDetailsScreen({super.key, required this.auctionId});
  final String auctionId;

  @override
  Widget build(BuildContext context) => FutureBuilder<AuctionProduct?>(
    future: context.read<AuctionProvider>().getAuction(auctionId),
    builder: (context, snapshot) {
      if (snapshot.hasError) return _state('Could not load this auction.');
      if (!snapshot.hasData) {
        return const Scaffold(
          appBar: Navbar(),
          body: Center(child: CircularProgressIndicator()),
        );
      }
      final auction = snapshot.data;
      if (auction == null || auction.endTime.isBefore(DateTime.now())) {
        return _state('This auction has ended or is no longer available.');
      }
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const Navbar(),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(builder: (context, constraints) {
                final image = ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      auction.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: AppColors.mint,
                        child: Icon(Icons.image_not_supported_outlined, size: 48),
                      ),
                    ),
                  ),
                );
                final details = _AuctionInfo(auction: auction);
                return constraints.maxWidth < 760
                    ? ListView(children: [image, const SizedBox(height: 24), details])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: image),
                          const SizedBox(width: 48),
                          Expanded(child: details),
                        ],
                      );
              }),
            ),
          ),
        ),
      );
    },
  );

  Widget _state(String message) => Scaffold(
    appBar: const Navbar(),
    body: Center(child: Text(message, style: const TextStyle(color: AppColors.mutedInk))),
  );
}

class _AuctionInfo extends StatelessWidget {
  const _AuctionInfo({required this.auction});
  final AuctionProduct auction;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(auction.category.toUpperCase(), style: const TextStyle(color: AppColors.brass, fontWeight: FontWeight.bold, letterSpacing: 1.4)),
      const SizedBox(height: 10),
      Text(auction.name, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12),
      Text('${auction.condition} condition', style: const TextStyle(color: AppColors.mutedInk)),
      const SizedBox(height: 28),
      const Text('CURRENT BID', style: TextStyle(color: AppColors.mutedInk, fontWeight: FontWeight.bold, letterSpacing: 1)),
      const SizedBox(height: 4),
      Text('৳${auction.currentBid.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.forestDeep, fontSize: 32, fontWeight: FontWeight.w900)),
      const SizedBox(height: 24),
      AuctionTimer(endTime: auction.endTime),
      const SizedBox(height: 24),
      Text(auction.description.isEmpty ? 'Contact us for details about this auction.' : auction.description, style: const TextStyle(color: AppColors.mutedInk, height: 1.6)),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () async {
            final uri = Uri.https(
              'm.me',
              AppConfig.messengerPageUsername,
              {'ref': 'auction_${auction.id}'},
            );
            final opened = await launchUrl(uri, webOnlyWindowName: '_blank');
            if (!opened && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open Messenger.')),
              );
            }
          },
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text('ASK ABOUT THIS AUCTION'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.forest, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18)),
        ),
      ),
    ],
  );
}
