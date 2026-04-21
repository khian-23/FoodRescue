import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/food_listing_model.dart';

class FoodListingService {
  FoodListingService({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;

  FirebaseFirestore get _firestoreClient =>
      _firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _listingCollection =>
      _firestoreClient.collection('food_listings');

  // =========================
  // SAFE STREAMS (AUTH-GUARDED)
  // =========================

  Stream<List<FoodListingModel>> streamAllListings() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _listingCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodListingModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList(growable: false);
    });
  }

  Stream<List<FoodListingModel>> streamListingsByOwner(String ownerUid) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _listingCollection
        .where('ownerUid', isEqualTo: ownerUid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    FoodListingModel.fromMap({...doc.data(), 'id': doc.id}),
              )
              .toList(growable: false);
        });
  }

  Stream<List<FoodListingModel>> streamAvailableListingsForRescuer(
    String rescuerUid,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _listingCollection
        .where('status', isEqualTo: 'open')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    FoodListingModel.fromMap({...doc.data(), 'id': doc.id}),
              )
              .where((listing) => listing.ownerUid != rescuerUid)
              .toList(growable: false);
        });
  }

  Stream<List<FoodListingModel>> streamClaimedListingsForRescuer(
    String rescuerUid,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return _listingCollection
        .where('claimedByUid', isEqualTo: rescuerUid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) =>
                    FoodListingModel.fromMap({...doc.data(), 'id': doc.id}),
              )
              .toList(growable: false);
        });
  }

  // =========================
  // CREATE LISTING
  // =========================

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

  // =========================
  // UPDATE LISTING (FULL)
  // =========================

  Future<void> updateListing(FoodListingModel listing) async {
    await _listingCollection
        .doc(listing.id)
        .set(listing.toMap(), SetOptions(merge: false));
  }

  // =========================
  // 🔥 FIXED: UPDATE STATUS (FOR ADMIN CONTROLLER)
  // =========================

  Future<void> updateListingStatus({
    required String listingId,
    required String status,
  }) async {
    await _listingCollection.doc(listingId).update({'status': status});
  }

  // =========================
  // CLAIM LISTING
  // =========================

  Future<void> claimListing({
    required FoodListingModel listing,
    required String rescuerUid,
    required String rescuerName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    final updateData = <String, dynamic>{
      'status': 'claimed',
      'claimedByUid': rescuerUid,
      'claimedByName': rescuerName,
    };

    print('DEBUG CLAIM UPDATE → ${listing.id}: $updateData');

    await _listingCollection.doc(listing.id).update(updateData);
  }

  // =========================
  // DELETE
  // =========================

  Future<void> deleteListing(String listingId) async {
    await _listingCollection.doc(listingId).delete();
  }
}
