import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionProduct {
  const AuctionProduct({
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
    this.description = '',
    this.published = true,
  });

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
  final String description;
  final bool published;

  factory AuctionProduct.fromMap(String id, Map<String, dynamic> data) {
    final end = data['endTime'];
    return AuctionProduct(
      id: id,
      name: data['name'] as String? ?? '',
      category: data['category'] as String? ?? '',
      condition: data['condition'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      galleryImages: (data['galleryImages'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      basePrice: (data['basePrice'] as num?)?.toDouble() ?? 0,
      currentBid: (data['currentBid'] as num?)?.toDouble() ?? 0,
      endTime: end is Timestamp
          ? end.toDate()
          : end is DateTime
          ? end
          : DateTime.fromMillisecondsSinceEpoch(0),
      totalBids: (data['totalBids'] as num?)?.toInt() ?? 0,
      description: data['description'] as String? ?? '',
      published: data['published'] as bool? ?? false,
    );
  }
}
