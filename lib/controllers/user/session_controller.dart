import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';

class SessionController {
  SessionController({
    AuthService? authService,
    UserService? userService,
  })  : _authService = authService ?? AuthService(),
        _userService = userService ?? UserService();

  final AuthService _authService;
  final UserService _userService;

  Future<UserModel?> loadCurrentUserProfile() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return null;
    }

    return _userService.getUserByUid(currentUser.uid);
  }

  Future<void> signOut() {
    return _authService.signOut();
  }
}
