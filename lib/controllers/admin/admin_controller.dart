import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class AdminController {
  AdminController({
    AuthService? authService,
    UserService? userService,
  })  : _authService = authService ?? AuthService(),
        userService = userService ?? UserService();

  final AuthService _authService;
  final UserService userService;

  Future<UserModel?> loadAdminProfile() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return null;
    }
    return userService.getUserByUid(currentUser.uid);
  }

  Future<void> signOut() {
    return _authService.signOut();
  }

  Future<void> updateUser({
    required String uid,
    required String name,
    required String role,
    required String userType,
  }) {
    return userService.updateUser(
      uid: uid,
      name: name,
      role: role,
      userType: userType,
    );
  }

  Future<void> deleteUser(String uid) {
    return userService.deleteUser(uid);
  }

  Future<bool> showEditDialog(BuildContext context, UserModel user) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: user.name);
    String selectedRole = user.role;
    String selectedUserType = user.userType;

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
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedUserType,
                  decoration: const InputDecoration(labelText: 'User type'),
                  items: const [
                    DropdownMenuItem(value: 'donor', child: Text('donor')),
                    DropdownMenuItem(value: 'rescuer', child: Text('rescuer')),
                  ],
                  onChanged: (value) {
                    selectedUserType = value ?? 'donor';
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
      return false;
    }

    await updateUser(
      uid: user.uid,
      name: nameController.text.trim(),
      role: selectedRole,
      userType: selectedUserType,
    );
    return true;
  }

  Future<bool> confirmDelete(BuildContext context, UserModel user) async {
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
      return false;
    }

    await deleteUser(user.uid);
    return true;
  }
}
