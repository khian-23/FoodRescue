import 'package:flutter/material.dart';

import '../../models/food_listing_model.dart';
import '../common/empty_state_card.dart';
import 'food_listing_card.dart';

class FoodListingList extends StatelessWidget {
  const FoodListingList({
    super.key,
    required this.stream,
    this.onEdit,
    this.onDelete,
    this.onClaim,
    this.emptyMessage = 'No food listings yet.',
  });

  final Stream<List<FoodListingModel>> stream;
  final void Function(FoodListingModel listing)? onEdit;
  final void Function(FoodListingModel listing)? onDelete;
  final void Function(FoodListingModel listing)? onClaim;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FoodListingModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateCard(
            icon: Icons.wifi_tethering_error_rounded,
            title: 'Listings unavailable',
            message: 'Failed to load food listings.',
          );
        }

        final listings = snapshot.data ?? [];
        if (listings.isEmpty) {
          return EmptyStateCard(
            icon: Icons.lunch_dining_outlined,
            title: 'No listings yet',
            message: emptyMessage,
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: listings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final listing = listings[index];
            return FoodListingCard(
              listing: listing,
              onEdit: onEdit == null ? null : () => onEdit!(listing),
              onDelete: onDelete == null ? null : () => onDelete!(listing),
              onClaim: onClaim == null ? null : () => onClaim!(listing),
            );
          },
        );
      },
    );
  }
}
