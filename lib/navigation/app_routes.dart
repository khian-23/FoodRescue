import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../screens/admin_dashboard.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/user_dashboard.dart';

class AppRoutes {
  static void goToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  static void goToRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  static void replaceWithLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  static void goToDashboardForRole(BuildContext context, UserModel user) {
    final screen = user.role == 'admin'
        ? const AdminDashboard()
        : const UserDashboard();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static void goToUserDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const UserDashboard()),
      (route) => false,
    );
  }
}
