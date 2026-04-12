import 'package:flutter/material.dart';

import '../controllers/admin_controller.dart';
import '../models/user_model.dart';
import '../navigation/app_routes.dart';
import '../widgets/admin/admin_user_list.dart';
import '../widgets/dashboard/dashboard_logout_button.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _adminController = AdminController();

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

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_adminTitle),
        actions: [
          DashboardLogoutButton(onPressed: _logout),
        ],
      ),
      body: AdminUserList(
        userService: _adminController.userService,
        onEdit: _showEditDialog,
        onDelete: _confirmDelete,
      ),
    );
  }
}
