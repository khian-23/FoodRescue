import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final _authService = AuthService();
  final _userService = UserService();

  bool _isCheckingAccess = true;
  String? _errorMessage;
  UserModel? _userProfile;

  @override
  void initState() {
    super.initState();
    _protectRouteAndLoadProfile();
  }

  Future<void> _protectRouteAndLoadProfile() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      _goToLogin();
      return;
    }

    try {
      final profile = await _userService.getUserByUid(currentUser.uid);
      if (!mounted) {
        return;
      }

      if (profile == null) {
        await _authService.signOut();
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
      await _authService.signOut();
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
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
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
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
            ),
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
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user.name}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text('Name: ${user.name}'),
                    const SizedBox(height: 8),
                    Text('Email: ${user.email}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Role: '),
                        Chip(
                          label: Text(user.role),
                          backgroundColor: Colors.green.shade100,
                        ),
                      ],
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
