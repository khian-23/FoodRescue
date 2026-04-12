import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/user_model.dart';
import 'screens/admin_dashboard.dart';
import 'screens/login_screen.dart';
import 'screens/user_dashboard.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FoodRescueApp());
}

class FoodRescueApp extends StatelessWidget {
  const FoodRescueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodRescue Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userService = UserService();

    return StreamBuilder(
      stream: authService.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final firebaseUser = authService.currentUser;
        if (firebaseUser == null) {
          return const LoginScreen();
        }

        return FutureBuilder<UserModel?>(
          future: userService.getUserByUid(firebaseUser.uid),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final appUser = userSnapshot.data;
            if (appUser == null) {
              return const LoginScreen();
            }

            if (appUser.role == 'admin') {
              return const AdminDashboard();
            }
            return const UserDashboard();
          },
        );
      },
    );
  }
}
