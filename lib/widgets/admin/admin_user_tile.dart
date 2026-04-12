import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class AdminUserTile extends StatelessWidget {
  const AdminUserTile({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
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
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
