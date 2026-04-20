import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food_listing_model.dart';

class FoodListingService {
  FoodListingService({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _firestoreClient =>
      _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _listingCollection =>
      _firestoreClient.collection('food_listings');

  Stream<List<FoodListingModel>> streamAllListings() {
    return _listingCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodListingModel.fromMap(doc.data()))
          .toList(growable: false);
    });
  }

  Stream<List<FoodListingModel>> streamListingsByOwner(String ownerUid) {
    return _listingCollection
        .where('ownerUid', isEqualTo: ownerUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodListingModel.fromMap(doc.data()))
          .toList(growable: false);
    });
  }

  Stream<List<FoodListingModel>> streamAvailableListingsForRescuer(
    String rescuerUid,
  ) {
    return _listingCollection
        .where('status', isEqualTo: 'open')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodListingModel.fromMap(doc.data()))
          .where((listing) => listing.ownerUid != rescuerUid)
          .toList(growable: false);
    });
  }

  Stream<List<FoodListingModel>> streamClaimedListingsForRescuer(
    String rescuerUid,
  ) {
    return _listingCollection
        .where('claimedByUid', isEqualTo: rescuerUid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodListingModel.fromMap(doc.data()))
          .toList(growable: false);
    });
  }

  Future<void> createListing({
    required String ownerUid,
    required String ownerName,
    required String title,
    required String description,
    required String quantity,
    required String pickupLocation,
    required String availableUntil,
  }) async {
    final doc = _listingCollection.doc();
    final listing = FoodListingModel(
      id: doc.id,
      ownerUid: ownerUid,
      ownerName: ownerName,
      title: title,
      description: description,
      quantity: quantity,
      pickupLocation: pickupLocation,
      availableUntil: availableUntil,
      status: 'open',
      claimedByUid: '',
      claimedByName: '',
    );

    await doc.set(listing.toMap());
  }

  Future<void> updateListing(FoodListingModel listing) async {
    await _listingCollection.doc(listing.id).update(listing.toMap());
  }

  Future<void> updateListingStatus({
    required String listingId,
    required String status,
  }) async {
    await _listingCollection.doc(listingId).update({'status': status});
  }

  Future<void> claimListing({
    required FoodListingModel listing,
    required String rescuerUid,
    required String rescuerName,
  }) async {
    await _listingCollection.doc(listing.id).update({
      'status': 'claimed',
      'claimedByUid': rescuerUid,
      'claimedByName': rescuerName,
    });
  }

  Future<void> deleteListing(String listingId) async {
    await _listingCollection.doc(listingId).delete();
  }
}
