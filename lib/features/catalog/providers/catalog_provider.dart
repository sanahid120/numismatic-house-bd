import 'package:image_picker/image_picker.dart';

import '../data/catalog_repository.dart';
import '../models/catalog_category.dart';
import '../models/product.dart';

class CatalogProvider {
  CatalogProvider(this._repository);

  final CatalogRepository _repository;

  Stream<List<Product>> watchPublishedProducts() =>
      _repository.watchPublishedProducts();

  Stream<List<Product>> watchAllProducts() => _repository.watchAllProducts();

  Stream<Product?> watchPublishedProduct(String id) =>
      _repository.watchPublishedProduct(id);

  Stream<List<String>> watchActiveCategories() =>
      _repository.watchActiveCategories();

  Stream<List<CatalogCategory>> watchAllCategories() =>
      _repository.watchAllCategories();

  Future<void> saveProduct({
    required Product product,
    required List<XFile> newImages,
  }) => _repository.saveProduct(product: product, newImages: newImages);

  Future<void> deleteProduct(Product product) =>
      _repository.deleteProduct(product);

  Future<void> saveCategory({
    required String name,
    String imageUrl = '',
    bool active = true,
    String? documentId,
  }) => _repository.saveCategory(
    name: name,
    imageUrl: imageUrl,
    active: active,
    documentId: documentId,
  );

  Future<void> deleteCategory(String id) => _repository.deleteCategory(id);
}
