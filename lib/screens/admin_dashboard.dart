import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'user_dashboard.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _authService = AuthService();
  final _userService = UserService();

  bool _isCheckingAccess = true;
  String _adminTitle = 'Admin Dashboard';

  @override
  void initState() {
    super.initState();
    _protectAdminRoute();
  }

  Future<void> _protectAdminRoute() async {
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

  void _goToUserDashboard() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const UserDashboard()),
      (route) => false,
    );
  }

  Future<void> _showEditDialog(UserModel user) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.name);
    String selectedRole = user.role;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('user')),
                    DropdownMenuItem(value: 'admin', child: Text('admin')),
                  ],
                  onChanged: (value) {
                    selectedRole = value ?? 'user';
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _userService.updateUser(
        uid: user.uid,
        name: nameController.text.trim(),
        role: selectedRole,
      );
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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete ${user.email}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    try {
      await _userService.deleteUser(user.uid);
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
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _userService.streamUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load users.'));
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(child: Text('No registered users yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final user = users[index];
              final roleColor =
                  user.role == 'admin' ? Colors.orange.shade100 : Colors.blue.shade100;

              return Card(
                child: ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(user.role),
                        backgroundColor: roleColor,
                      ),
                      IconButton(
                        onPressed: () => _showEditDialog(user),
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(user),
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
