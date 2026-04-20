import 'package:flutter/material.dart';

class DashboardLogoutButton extends StatelessWidget {
  const DashboardLogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.logout),
      tooltip: 'Logout',
    );
  }
}
