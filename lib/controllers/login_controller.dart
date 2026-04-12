import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class LoginController {
  LoginController({
    AuthService? authService,
    UserService? userService,
  })  : _authService = authService ?? AuthService(),
        _userService = userService ?? UserService();

  final AuthService _authService;
  final UserService _userService;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signIn(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      throw AppAuthException('Unable to sign in right now. Please try again.');
    }

    final appUser = await _userService.getUserByUid(firebaseUser.uid);
    if (appUser == null) {
      throw AppAuthException('Account profile not found. Please contact admin.');
    }

    return appUser;
  }
}
