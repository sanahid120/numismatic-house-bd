import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/auction.dart';

class AuctionRepository {
  AuctionRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  CollectionReference<Map<String, dynamic>> get _auctions =>
      _firestore.collection('auctions');

  Stream<List<AuctionProduct>> watchPublishedAuctions() => _auctions
      .where('published', isEqualTo: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AuctionProduct.fromMap(doc.id, doc.data()))
          .toList(growable: false));

  Stream<List<AuctionProduct>> watchAllAuctions() => _auctions
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => AuctionProduct.fromMap(doc.id, doc.data()))
          .toList(growable: false));

  Future<AuctionProduct?> getAuction(String id) async {
    final document = await _auctions.doc(id).get();
    if (!document.exists || document.data()?['published'] != true) return null;
    return AuctionProduct.fromMap(document.id, document.data()!);
  }

  Future<void> saveAuction({
    required AuctionProduct auction,
    required List<XFile> newImages,
  }) async {
    if (auction.endTime.isBefore(DateTime.now())) {
      throw ArgumentError('Auction end time must be in the future.');
    }
    if (newImages.length > 10) {
      throw ArgumentError('An auction can have at most 10 images.');
    }

    final isNew = auction.id.isEmpty;
    final document = isNew ? _auctions.doc() : _auctions.doc(auction.id);
    final gallery = [...auction.galleryImages];
    for (var index = 0; index < newImages.length; index++) {
      final image = newImages[index];
      final bytes = await image.readAsBytes();
      if (bytes.length > 8 * 1024 * 1024) {
        throw ArgumentError('Each image must be 8 MB or smaller.');
      }
      final extension = _safeExtension(image.name);
      final ref = _storage.ref(
        'auctions/${document.id}/${DateTime.now().microsecondsSinceEpoch}_$index.$extension',
      );
      await ref.putData(bytes, SettableMetadata(contentType: _contentType(extension)));
      gallery.add(await ref.getDownloadURL());
    }
    await document.set({
      'id': document.id,
      'name': auction.name.trim(),
      'category': auction.category.trim(),
      'condition': auction.condition.trim(),
      'imageUrl': gallery.isEmpty ? auction.imageUrl : gallery.first,
      'galleryImages': gallery.take(10).toList(),
      'basePrice': auction.basePrice,
      'currentBid': isNew ? auction.basePrice : auction.currentBid,
      'endTime': Timestamp.fromDate(auction.endTime),
      'totalBids': isNew ? 0 : auction.totalBids,
      'description': auction.description.trim(),
      'published': auction.published,
      'updatedAt': FieldValue.serverTimestamp(),
      if (isNew) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteAuction(AuctionProduct auction) async {
    await _auctions.doc(auction.id).delete();
    try {
      final files = await _storage.ref('auctions/${auction.id}').listAll();
      await Future.wait(files.items.map((file) => file.delete()));
    } on FirebaseException {
      // A cleanup failure leaves only an orphaned image, not a live auction.
    }
  }

  String _safeExtension(String name) {
    final extension = name.split('.').last.toLowerCase();
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
