import 'package:flutter/material.dart';

/// A compact account menu placed in the app bar.
///
/// Shows a small avatar/button and exposes a popup menu with actions
/// including "Logout". Selecting "Logout" calls the provided
/// [onPressed] callback so existing callers don't need to change.
class DashboardLogoutButton extends StatelessWidget {
  const DashboardLogoutButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account menu',
      onSelected: (value) {
        if (value == 'logout') {
          onPressed();
        }
        // Other menu values can be handled by the caller later if needed.
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'profile', child: Text('Profile')),
        const PopupMenuItem(value: 'settings', child: Text('Settings')),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
      // Small circular touch target so it reads like an account control.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            Icons.person,
            size: 18,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
