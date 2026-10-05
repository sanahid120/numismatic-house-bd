class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.condition,
    required this.imageUrl,
    this.galleryImages = const [],
    required this.price,
    this.originalPrice,
    this.isAuction = false,
    this.description = '',
    this.published = true,
  });

  final String id;
  final String name;
  final String category;
  final String condition;
  final String imageUrl;
  final List<String> galleryImages;
  final double price;
  final double? originalPrice;
  final bool isAuction;
  final String description;
  final bool published;

  factory Product.fromMap(String id, Map<String, dynamic> data) => Product(
    id: id,
    name: data['name'] as String? ?? '',
    category: data['category'] as String? ?? '',
    condition: data['condition'] as String? ?? '',
    imageUrl: data['imageUrl'] as String? ?? '',
    galleryImages: (data['galleryImages'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList(growable: false),
    price: (data['price'] as num?)?.toDouble() ?? 0,
    originalPrice: (data['originalPrice'] as num?)?.toDouble(),
    isAuction: data['isAuction'] as bool? ?? false,
    description: data['description'] as String? ?? '',
    published: data['published'] as bool? ?? false,
  );
}
