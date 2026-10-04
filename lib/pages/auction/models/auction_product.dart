class AuctionProduct {
  final String id;
  final String name;
  final String category;
  final String condition;
  final String imageUrl;
  final List<String> galleryImages;
  final double basePrice;
  final double currentBid;
  final DateTime endTime;
  final int totalBids;

  AuctionProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.condition,
    required this.imageUrl,
    this.galleryImages = const [],
    required this.basePrice,
    required this.currentBid,
    required this.endTime,
    this.totalBids = 0,
  });
}

final List<AuctionProduct> demoAuctions = [
  AuctionProduct(
    id: 'auc_1',
    name: 'Rare 10 Taka Note 1972 - Low Serial',
    category: 'Bangladeshi',
    condition: 'UNC',
    imageUrl: 'https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=600&fit=crop',
    galleryImages: ['https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=600&fit=crop'],
    basePrice: 5000,
    currentBid: 7500,
    endTime: DateTime.now().add(const Duration(days: 2, hours: 5, minutes: 30)),
    totalBids: 12,
  ),
  AuctionProduct(
    id: 'auc_2',
    name: 'Pakistan 100 Rupee 1948 - Overprint',
    category: 'Pakistani',
    condition: 'AUNC',
    imageUrl: 'https://images.unsplash.com/photo-1599059813005-11265ba4b4ce?q=80&w=600&fit=crop',
    basePrice: 12000,
    currentBid: 15500,
    endTime: DateTime.now().add(const Duration(hours: 3, minutes: 45)),
    totalBids: 8,
  ),
];
