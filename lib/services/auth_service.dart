import 'package:firebase_auth/firebase_auth.dart';

import 'user_service.dart';

class AppAuthException implements Exception {
  AppAuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService {
  AuthService({FirebaseAuth? auth, UserService? userService})
    : _auth = auth,
      _userService = userService ?? UserService();

  final FirebaseAuth? _auth;
  final UserService _userService;

  FirebaseAuth get _authClient => _auth ?? FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _authClient.authStateChanges();

  User? get currentUser => _authClient.currentUser;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    }
  }

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) async {
    try {
      final credential = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw AppAuthException('Registration failed. Please try again.');
      }

      try {
        await _userService.createUserProfile(
          uid: user.uid,
          name: name,
          email: email,
          role: 'user',
          userType: userType,
        );
      } catch (_) {
        await user.delete();
        throw AppAuthException(
          'Unable to save your profile right now. Please try again.',
        );
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AppAuthException(_mapAuthError(e));
    }
  }

  Future<void> signOut() async {
    await _authClient.signOut();
  }

  String _mapAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
