import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/catalog_category.dart';
import '../models/product.dart';

class CatalogRepository {
  CatalogRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> watchPublishedProducts() => _products
      .where('published', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList(growable: false));

  Stream<List<Product>> watchAllProducts() => _products
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList(growable: false));

  Stream<Product?> watchPublishedProduct(String id) => _products
      .doc(id)
      .snapshots()
      .map((document) {
        final data = document.data();
        if (!document.exists || data == null || data['published'] != true) {
          return null;
        }
        return Product.fromMap(document.id, data);
      });

  Stream<List<String>> watchActiveCategories() => _firestore
      .collection('categories')
      .where('active', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => doc.data()['name'])
          .whereType<String>()
          .toList(growable: false));

  Stream<List<CatalogCategory>> watchAllCategories() => _firestore
      .collection('categories')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CatalogCategory.fromMap(doc.id, doc.data()))
          .toList(growable: false));

  Future<void> saveProduct({
    required Product product,
    required List<XFile> newImages,
  }) async {
    if (newImages.length > 10) {
      throw ArgumentError('A product can have at most 10 images.');
    }

    final isNewProduct = product.id.isEmpty;
    final document = isNewProduct
        ? _products.doc()
        : _products.doc(product.id);
    final imageUrls = <String>[];

    for (var index = 0; index < newImages.length; index++) {
      final file = newImages[index];
      final bytes = await file.readAsBytes();
      if (bytes.length > 8 * 1024 * 1024) {
        throw ArgumentError('Each image must be 8 MB or smaller.');
      }
      final extension = _safeExtension(file.name);
      final reference = _storage.ref(
        'products/${document.id}/${DateTime.now().microsecondsSinceEpoch}_$index.$extension',
      );
      final task = await reference.putData(
        bytes,
        SettableMetadata(contentType: _contentType(extension)),
      );
      imageUrls.add(await task.ref.getDownloadURL());
    }

    final allImages = imageUrls.isEmpty
        ? product.galleryImages
        : [...product.galleryImages, ...imageUrls].take(10).toList();
    final data = <String, dynamic>{
      'id': document.id,
      'name': product.name.trim(),
      'category': product.category.trim(),
      'condition': product.condition.trim(),
      'imageUrl': allImages.isEmpty ? product.imageUrl : allImages.first,
      'galleryImages': allImages,
      'price': product.price,
      'originalPrice': product.originalPrice,
      'isAuction': product.isAuction,
      'description': product.description.trim(),
      'published': product.published,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (isNewProduct) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    await document.set(data, SetOptions(merge: true));
  }

  Future<void> deleteProduct(Product product) async {
    await _products.doc(product.id).delete();
    try {
      final folder = await _storage.ref('products/${product.id}').listAll();
      await Future.wait(folder.items.map((item) => item.delete()));
    } on FirebaseException catch (error) {
      // Keep the catalog operation successful if orphan cleanup fails; the
      // storage rules still prevent public writes and the orphan can be cleaned
      // up administratively.
      debugPrint('Product image cleanup failed: ${error.code}');
    }
  }

  Future<void> saveCategory({
    required String name,
    String imageUrl = '',
    bool active = true,
    String? documentId,
  }) async {
    final collection = _firestore.collection('categories');
    final reference = documentId == null
        ? collection.doc()
        : collection.doc(documentId);
    await reference.set({
      'name': name.trim(),
      'imageUrl': imageUrl.trim(),
      'active': active,
      'updatedAt': FieldValue.serverTimestamp(),
      if (documentId == null) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteCategory(String id) =>
      _firestore.collection('categories').doc(id).delete();

  String _safeExtension(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return const {'jpg', 'jpeg', 'png', 'webp'}.contains(extension)
        ? extension
        : 'jpg';
  }

  String _contentType(String extension) => switch (extension) {
    'png' => 'image/png',
    'webp' => 'image/webp',
    _ => 'image/jpeg',
  };
}
