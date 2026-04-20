import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';
import '../common/empty_state_card.dart';
import 'admin_user_tile.dart';

class AdminUserList extends StatelessWidget {
  const AdminUserList({
    super.key,
    required this.userService,
    required this.onEdit,
    required this.onDelete,
  });

  final UserService userService;
  final void Function(UserModel user) onEdit;
  final void Function(UserModel user) onDelete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream: userService.streamUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateCard(
            icon: Icons.person_off_outlined,
            title: 'Users unavailable',
            message: 'Failed to load users.',
          );
        }

        final users = snapshot.data ?? [];
        if (users.isEmpty) {
          return const EmptyStateCard(
            icon: Icons.groups_outlined,
            title: 'No users yet',
            message: 'No registered users yet.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: users.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final user = users[index];
            return AdminUserTile(
              user: user,
              onEdit: () => onEdit(user),
              onDelete: () => onDelete(user),
            );
          },
        );
      },
    );
  }
}
