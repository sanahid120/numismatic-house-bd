class CatalogCategory {
  const CatalogCategory({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.active = true,
  });

  final String id;
  final String name;
  final String imageUrl;
  final bool active;

  factory CatalogCategory.fromMap(String id, Map<String, dynamic> data) =>
      CatalogCategory(
        id: id,
        name: data['name'] as String? ?? '',
        imageUrl: data['imageUrl'] as String? ?? '',
        active: data['active'] as bool? ?? false,
      );
}
