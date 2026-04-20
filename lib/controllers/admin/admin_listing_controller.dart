import 'package:flutter/material.dart';

import '../../models/food_listing_model.dart';
import '../../services/food_listing_service.dart';

class AdminListingController {
  AdminListingController({FoodListingService? listingService})
      : listingService = listingService ?? FoodListingService();

  final FoodListingService listingService;

  Stream<List<FoodListingModel>> streamAllListings() {
    return listingService.streamAllListings();
  }

  Future<void> updateStatus({
    required String listingId,
    required String status,
  }) {
    return listingService.updateListingStatus(
      listingId: listingId,
      status: status,
    );
  }

  Future<void> deleteListing(String listingId) {
    return listingService.deleteListing(listingId);
  }

  Future<bool> showStatusDialog(
    BuildContext context,
    FoodListingModel listing,
  ) async {
    String selectedStatus = listing.status;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Listing Status'),
          content: DropdownButtonFormField<String>(
            initialValue: selectedStatus,
            decoration: const InputDecoration(labelText: 'Status'),
            items: const [
              DropdownMenuItem(value: 'open', child: Text('open')),
              DropdownMenuItem(value: 'claimed', child: Text('claimed')),
              DropdownMenuItem(value: 'completed', child: Text('completed')),
            ],
            onChanged: (value) {
              selectedStatus = value ?? listing.status;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return false;
    }

    await updateStatus(listingId: listing.id, status: selectedStatus);
    return true;
  }

  Future<bool> confirmDelete(BuildContext context, FoodListingModel listing) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Listing'),
          content: Text('Delete "${listing.title}" by ${listing.ownerName}?'),
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
