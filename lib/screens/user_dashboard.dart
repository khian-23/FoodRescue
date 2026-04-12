import 'package:flutter/material.dart';

import '../controllers/session_controller.dart';
import '../models/user_model.dart';
import '../navigation/app_routes.dart';
import '../widgets/dashboard/dashboard_logout_button.dart';
import '../widgets/dashboard/user_profile_card.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final _sessionController = SessionController();

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

  @override
  Widget build(BuildContext context) {
    if (_isCheckingAccess) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Dashboard'),
          actions: [
            DashboardLogoutButton(onPressed: _logout),
          ],
        ),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    final user = _userProfile;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('User profile not found.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name.isNotEmpty ? user.name : user.email),
        actions: [
          DashboardLogoutButton(onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: UserProfileCard(user: user),
          ),
        ),
      ),
    );
  }
}
