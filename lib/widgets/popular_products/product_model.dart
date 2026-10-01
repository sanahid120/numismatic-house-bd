class Product {
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String condition;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.condition = 'UNC',
  });
}

final List<Product> popularProducts = [
  Product(
    name: '2 Taka - Doyel Bird (Rare)',
    category: 'Bangladeshi',
    price: 150.0,
    imageUrl: 'https://images.unsplash.com/photo-1628527304948-06157ee3c8a6?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
  Product(
    name: '10 Rupee - Quaid-e-Azam',
    category: 'Pakistani',
    price: 250.0,
    imageUrl: 'https://images.unsplash.com/photo-1599059813005-11265ba4b4ce?q=80&w=400&fit=crop',
    condition: 'AUNC',
  ),
  Product(
    name: '1 Dollar - George Washington',
    category: 'Foreign',
    price: 120.0,
    imageUrl: 'https://images.unsplash.com/photo-1502920514313-52581002a659?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
  Product(
    name: '5 Taka - Agriculture (Jute)',
    category: 'Bangladeshi',
    price: 80.0,
    imageUrl: 'https://images.unsplash.com/photo-1589750670744-dc963161a917?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
  Product(
    name: '1000 Yen - Hideyo Noguchi',
    category: 'Foreign',
    price: 1200.0,
    imageUrl: 'https://images.unsplash.com/photo-1613243555988-441166d4d6fd?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
  Product(
    name: '500 Rupee - Historical',
    category: 'Pakistani',
    price: 650.0,
    imageUrl: 'https://images.unsplash.com/photo-1605792657660-596af9009e82?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
  Product(
    name: '10 Euro - European Gateway',
    category: 'Foreign',
    price: 1400.0,
    imageUrl: 'https://images.unsplash.com/photo-1554672723-b208dc85134f?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
  Product(
    name: '50 Taka - Golden Jubilee',
    category: 'Bangladeshi',
    price: 300.0,
    imageUrl: 'https://images.unsplash.com/photo-1561414927-6d86591d0c4f?q=80&w=400&fit=crop',
    condition: 'UNC',
  ),
];
