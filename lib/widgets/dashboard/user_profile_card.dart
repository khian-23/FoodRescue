import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
