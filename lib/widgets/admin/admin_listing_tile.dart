import 'package:flutter/material.dart';

import '../../models/food_listing_model.dart';
import '../../theme/app_theme.dart';

class AdminListingTile extends StatelessWidget {
  const AdminListingTile({
    super.key,
    required this.listing,
    required this.onStatusEdit,
    required this.onDelete,
  });

  final FoodListingModel listing;
  final VoidCallback onStatusEdit;
  final VoidCallback onDelete;

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
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.sage.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.storefront_outlined,
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
                      const SizedBox(height: 4),
                      Text(
                        'By ${listing.ownerName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.forest.withValues(alpha: 0.72),
                            ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(listing.status),
                  backgroundColor: _statusColor(listing.status),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _ListingPill(
                  icon: Icons.place_outlined,
                  label: listing.pickupLocation,
                ),
                _ListingPill(
                  icon: Icons.schedule_outlined,
                  label: listing.availableUntil,
                ),
                _ListingPill(
                  icon: Icons.inventory_2_outlined,
                  label: listing.quantity,
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
                  color: AppTheme.sand.withValues(alpha: 0.42),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Claimed by ${listing.claimedByName}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: onStatusEdit,
                  icon: const Icon(Icons.tune, size: 18),
                  label: const Text('Status'),
                ),
                const SizedBox(width: 8),
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

class _ListingPill extends StatelessWidget {
  const _ListingPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.68),
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

Color _statusColor(String status) {
  switch (status) {
    case 'claimed':
      return AppTheme.sand;
    case 'completed':
      return AppTheme.sage;
    default:
      return AppTheme.sage.withValues(alpha: 0.85);
  }
}
