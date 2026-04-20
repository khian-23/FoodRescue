import 'package:flutter/material.dart';

import '../../models/food_listing_model.dart';
import '../../theme/app_theme.dart';

class FoodListingCard extends StatelessWidget {
  const FoodListingCard({
    super.key,
    required this.listing,
    this.onEdit,
    this.onDelete,
    this.onClaim,
  });

  final FoodListingModel listing;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.sage.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_outlined,
                    color: AppTheme.forest,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        listing.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.forest.withValues(alpha: 0.76),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _StatusChip(status: listing.status),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ListingMetaPill(
                  icon: Icons.inventory_2_outlined,
                  label: listing.quantity,
                ),
                _ListingMetaPill(
                  icon: Icons.place_outlined,
                  label: listing.pickupLocation,
                ),
                _ListingMetaPill(
                  icon: Icons.schedule_outlined,
                  label: listing.availableUntil,
                ),
              ],
            ),
            if (listing.claimedByName.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.sand.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.handshake_outlined,
                      size: 18,
                      color: AppTheme.forest,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Claimed by ${listing.claimedByName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onClaim != null)
                  ElevatedButton.icon(
                    onPressed: onClaim,
                    icon: const Icon(Icons.handshake_outlined),
                    label: const Text('Claim Pickup'),
                  ),
                if (onEdit != null)
                  OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                  ),
                if (onDelete != null)
                  OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Delete'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status),
      backgroundColor: switch (status) {
        'claimed' => AppTheme.sand,
        'completed' => AppTheme.sage,
        _ => AppTheme.sage.withValues(alpha: 0.85),
      },
    );
  }
}

class _ListingMetaPill extends StatelessWidget {
  const _ListingMetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: AppTheme.leaf),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
