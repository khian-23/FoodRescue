import 'package:flutter/material.dart';

import '../../controllers/admin/admin_controller.dart';
import '../../controllers/admin/admin_listing_controller.dart';
import '../../models/food_listing_model.dart';
import '../../models/user_model.dart';
import '../../navigation/app_routes.dart';
import '../../widgets/admin/admin_listing_list.dart';
import '../../widgets/admin/admin_user_list.dart';
import '../../widgets/common/dashboard_stat_card.dart';
import '../../widgets/common/logout_button.dart';
import '../../widgets/common/page_background.dart';
import '../../widgets/common/section_header.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _adminController = AdminController();
  final _adminListingController = AdminListingController();

  bool _isCheckingAccess = true;
  String _adminTitle = 'Admin Dashboard';

  @override
  void initState() {
    super.initState();
    _protectAdminRoute();
  }

  Future<void> _protectAdminRoute() async {
    try {
      final profile = await _adminController.loadAdminProfile();
      if (!mounted) {
        return;
      }

      if (profile == null) {
        await _adminController.signOut();
        _goToLogin();
        return;
      }

      if (profile.role != 'admin') {
        _goToUserDashboard();
        return;
      }

      setState(() {
        _adminTitle =
            profile.name.isNotEmpty ? '${profile.name} (Admin)' : 'Admin Dashboard';
        _isCheckingAccess = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      _goToUserDashboard();
    }
  }

  Future<void> _logout() async {
    try {
      await _adminController.signOut();
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

  void _goToUserDashboard() {
    AppRoutes.goToUserDashboard(context);
  }

  Future<void> _showEditDialog(UserModel user) async {
    try {
      final updated = await _adminController.showEditDialog(context, user);
      if (!updated || !mounted) {
        return;
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated ${user.email} successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update user.')),
      );
    }
  }

  Future<void> _confirmDelete(UserModel user) async {
    try {
      final deleted = await _adminController.confirmDelete(context, user);
      if (!deleted || !mounted) {
        return;
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.email} deleted successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete user.')),
      );
    }
  }

  Future<void> _updateListingStatus(FoodListingModel listing) async {
    try {
      final updated = await _adminListingController.showStatusDialog(
        context,
        listing,
      );
      if (!updated || !mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing status updated successfully.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update listing status.')),
      );
    }
  }

  Future<void> _deleteListing(FoodListingModel listing) async {
    try {
      final deleted = await _adminListingController.confirmDelete(
        context,
        listing,
      );
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

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_adminTitle),
          actions: [
            DashboardLogoutButton(onPressed: _logout),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Listings'),
            ],
          ),
        ),
        body: PageBackground(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TabBarView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: const [
                        SizedBox(
                          width: 180,
                          height: 132,
                          child: DashboardStatCard(
                            label: 'Access Scope',
                            value: 'ADMIN',
                            icon: Icons.admin_panel_settings_outlined,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 132,
                          child: DashboardStatCard(
                            label: 'User Controls',
                            value: 'LIVE',
                            icon: Icons.groups_outlined,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 132,
                          child: DashboardStatCard(
                            label: 'Listing Controls',
                            value: 'REALTIME',
                            icon: Icons.inventory_2_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const SectionHeader(
                      title: 'User Management',
                      subtitle:
                          'Monitor registered users and update access in real time.',
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: AdminUserList(
                        userService: _adminController.userService,
                        onEdit: _showEditDialog,
                        onDelete: _confirmDelete,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: const [
                        SizedBox(
                          width: 180,
                          height: 132,
                          child: DashboardStatCard(
                            label: 'Feed Visibility',
                            value: 'ALL',
                            icon: Icons.public_outlined,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 132,
                          child: DashboardStatCard(
                            label: 'Status Control',
                            value: 'OPEN-CLAIMED',
                            icon: Icons.tune_outlined,
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          height: 132,
                          child: DashboardStatCard(
                            label: 'Moderation',
                            value: 'DELETE',
                            icon: Icons.delete_sweep_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const SectionHeader(
                      title: 'Food Listings',
                      subtitle:
                          'Track all rescue listings and update their availability.',
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: AdminListingList(
                        controller: _adminListingController,
                        onStatusEdit: _updateListingStatus,
                        onDelete: _deleteListing,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
