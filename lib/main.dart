import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'models/user_model.dart';
import 'screens/admin_dashboard.dart';
import 'screens/login_screen.dart';
import 'screens/user_dashboard.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await _initializeFirebase();
  runApp(FoodRescueApp(firebaseReady: firebaseReady));
}

Future<bool> _initializeFirebase() async {
  if (!DefaultFirebaseOptions.isSupportedPlatform) {
    return false;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return true;
}

class FoodRescueApp extends StatelessWidget {
  const FoodRescueApp({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodRescue Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: firebaseReady
          ? const AuthGate()
          : const UnsupportedPlatformScreen(),
    );
  }
}

class UnsupportedPlatformScreen extends StatelessWidget {
  const UnsupportedPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone_android, size: 56),
                const SizedBox(height: 16),
                Text(
                  'This app is configured for Android and iOS.',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'The current Linux desktop target does not have Firebase '
                  'plugin support configured in this project. Run the app on '
                  'Android, or move the project to macOS for iOS builds.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
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
