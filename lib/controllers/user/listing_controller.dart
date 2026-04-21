import 'package:flutter/material.dart';

import '../../models/food_listing_model.dart';
import '../../models/user_model.dart';
import '../../services/food_listing_service.dart';

class ListingController {
  ListingController({FoodListingService? listingService})
    : listingService = listingService ?? FoodListingService();

  final FoodListingService listingService;

  Stream<List<FoodListingModel>> streamListingsForUser(String ownerUid) {
    return listingService.streamListingsByOwner(ownerUid);
  }

  Stream<List<FoodListingModel>> streamAvailableListingsForRescuer(
    String rescuerUid,
  ) {
    return listingService.streamAvailableListingsForRescuer(rescuerUid);
  }

  Stream<List<FoodListingModel>> streamClaimedListingsForRescuer(
    String rescuerUid,
  ) {
    return listingService.streamClaimedListingsForRescuer(rescuerUid);
  }

  Future<void> createListing({
    required UserModel owner,
    required String title,
    required String description,
    required String quantity,
    required String pickupLocation,
    required String availableUntil,
  }) {
    return listingService.createListing(
      ownerUid: owner.uid,
      ownerName: owner.name,
      title: title,
      description: description,
      quantity: quantity,
      pickupLocation: pickupLocation,
      availableUntil: availableUntil,
    );
  }

  Future<void> updateListing(FoodListingModel listing) {
    return listingService.updateListing(listing);
  }

  Future<void> deleteListing(String listingId) {
    return listingService.deleteListing(listingId);
  }

  Future<void> claimListing({
    required FoodListingModel listing,
    required UserModel rescuer,
  }) {
    try {
      print(
        'DEBUG: ListingController.claimListing listingId=${listing.id} rescuerUid=${rescuer.uid} rescuerName=${rescuer.name}',
      );
    } catch (_) {}
    return listingService.claimListing(
      listing: listing,
      rescuerUid: rescuer.uid,
      rescuerName: rescuer.name,
    );
  }

  Future<bool> confirmDelete(
    BuildContext context,
    FoodListingModel listing,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Listing'),
          content: Text('Remove "${listing.title}" from your listings?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return false;
    }

    await deleteListing(listing.id);
    return true;
  }
}
