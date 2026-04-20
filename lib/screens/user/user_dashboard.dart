import 'package:flutter/material.dart';

import '../../controllers/user/listing_controller.dart';
import '../../models/food_listing_model.dart';
import '../../controllers/user/session_controller.dart';
import '../../models/user_model.dart';
import '../../navigation/app_routes.dart';
import '../../widgets/common/logout_button.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/user/food_listing_form_dialog.dart';
import '../../widgets/user/food_listing_list.dart';
import '../../widgets/user/user_profile_card.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final _sessionController = SessionController();
  final _listingController = ListingController();

  bool _isCheckingAccess = true;
  String? _errorMessage;
  UserModel? _userProfile;

  @override
  void initState() {
    super.initState();
    _protectRouteAndLoadProfile();
  }

  Future<void> _protectRouteAndLoadProfile() async {
    try {
      final profile = await _sessionController.loadCurrentUserProfile();
      if (!mounted) {
        return;
      }

      if (profile == null) {
        await _sessionController.signOut();
        _goToLogin();
        return;
      }

      setState(() {
        _userProfile = profile;
        _isCheckingAccess = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Failed to load your profile.';
        _isCheckingAccess = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _sessionController.signOut();
      if (!mounted) {
        return;
      }
      _goToLogin();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to log out right now.')),
      );
    }
  }

  void _goToLogin() {
    AppRoutes.goToLogin(context);
  }

  Future<void> _createListing() async {
    final user = _userProfile;
    if (user == null) {
      return;
    }

    final formData = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const FoodListingFormDialog(),
    );

    if (formData == null) {
      return;
    }

    try {
      await _listingController.createListing(
        owner: user,
        title: formData['title']!,
        description: formData['description']!,
        quantity: formData['quantity']!,
        pickupLocation: formData['pickupLocation']!,
        availableUntil: formData['availableUntil']!,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing created successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create listing.')),
      );
    }
  }

  Future<void> _editListing(FoodListingModel listing) async {
    final formData = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => FoodListingFormDialog(initialListing: listing),
    );

    if (formData == null) {
      return;
    }

    try {
      await _listingController.updateListing(
        listing.copyWith(
          title: formData['title'],
          description: formData['description'],
          quantity: formData['quantity'],
          pickupLocation: formData['pickupLocation'],
          availableUntil: formData['availableUntil'],
        ),
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing updated successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update listing.')),
      );
    }
  }

  Future<void> _deleteListing(FoodListingModel listing) async {
    try {
      final deleted = await _listingController.confirmDelete(context, listing);
      if (!deleted || !mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing deleted successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete listing.')),
      );
    }
  }

  Future<void> _claimListing(FoodListingModel listing) async {
    final user = _userProfile;
    if (user == null) {
      return;
    }

    try {
      await _listingController.claimListing(listing: listing, rescuer: user);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You claimed "${listing.title}".')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to claim listing.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Dashboard'),
          actions: [DashboardLogoutButton(onPressed: _logout)],
        ),
        body: PageBackground(child: Center(child: Text(_errorMessage!))),
      );
    }

    final user = _userProfile;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User profile not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name.isNotEmpty ? user.name : user.email),
        actions: [DashboardLogoutButton(onPressed: _logout)],
      ),
      body: PageBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: user.userType == 'rescuer'
                          ? 'Rescuer Dashboard'
                          : 'Donor Dashboard',
                      subtitle: user.userType == 'rescuer'
                          ? 'Browse open food offers and claim pickups.'
                          : 'Review your account details and manage your rescue listings.',
                    ),
                    const SizedBox(height: 18),
                    UserProfileCard(user: user),
                    const SizedBox(height: 24),
                    if (user.userType == 'donor')
                      SectionHeader(
                        title: 'My Food Listings',
                        subtitle:
                            'Create and update available food rescue items.',
                        trailing: ElevatedButton.icon(
                          onPressed: _createListing,
                          icon: const Icon(Icons.add),
                          label: const Text('New Listing'),
                        ),
                      )
                    else
                      const SectionHeader(
                        title: 'Available Food Listings',
                        subtitle:
                            'Open listings from donors and restaurants ready for pickup.',
                      ),
                    const SizedBox(height: 14),
                    FoodListingList(
                      stream: user.userType == 'rescuer'
                          ? _listingController
                                .streamAvailableListingsForRescuer(user.uid)
                          : _listingController.streamListingsForUser(user.uid),
                      emptyMessage: user.userType == 'rescuer'
                          ? 'No open food listings are available right now.'
                          : 'No food listings yet. Add your first available item.',
                      onEdit: user.userType == 'donor' ? _editListing : null,
                      onDelete: user.userType == 'donor'
                          ? _deleteListing
                          : null,
                      onClaim: user.userType == 'rescuer'
                          ? _claimListing
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
