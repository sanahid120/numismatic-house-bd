import 'package:image_picker/image_picker.dart';

import '../data/auction_repository.dart';
import '../models/auction.dart';

class AuctionProvider {
  AuctionProvider(this._repository);
  final AuctionRepository _repository;

  Stream<List<AuctionProduct>> watchPublishedAuctions() =>
      _repository.watchPublishedAuctions();
  Stream<List<AuctionProduct>> watchAllAuctions() =>
      _repository.watchAllAuctions();
  Future<AuctionProduct?> getAuction(String id) => _repository.getAuction(id);
  Future<void> saveAuction({
    required AuctionProduct auction,
    required List<XFile> newImages,
  }) => _repository.saveAuction(auction: auction, newImages: newImages);
  Future<void> deleteAuction(AuctionProduct auction) =>
      _repository.deleteAuction(auction);
}
