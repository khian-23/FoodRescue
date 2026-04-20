import 'package:flutter/material.dart';

import '../../controllers/admin/admin_listing_controller.dart';
import '../../models/food_listing_model.dart';
import '../common/empty_state_card.dart';
import 'admin_listing_tile.dart';

class AdminListingList extends StatelessWidget {
  const AdminListingList({
    super.key,
    required this.controller,
    required this.onStatusEdit,
    required this.onDelete,
  });

  final AdminListingController controller;
  final void Function(FoodListingModel listing) onStatusEdit;
  final void Function(FoodListingModel listing) onDelete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FoodListingModel>>(
      stream: controller.streamAllListings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateCard(
            icon: Icons.error_outline,
            title: 'Listings unavailable',
            message: 'Failed to load listings.',
          );
        }

        final listings = snapshot.data ?? [];
        if (listings.isEmpty) {
          return const EmptyStateCard(
            icon: Icons.inventory_2_outlined,
            title: 'No listings yet',
            message: 'No food listings available.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: listings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final listing = listings[index];
            return AdminListingTile(
              listing: listing,
              onStatusEdit: () => onStatusEdit(listing),
              onDelete: () => onDelete(listing),
            );
          },
        );
      },
    );
  }
}
