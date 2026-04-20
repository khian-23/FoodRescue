import '../../services/auth_service.dart';

class RegisterController {
  RegisterController({AuthService? authService})
      : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String userType,
  }) {
    return _authService.register(
      name: name,
      email: email,
      password: password,
      userType: userType,
    );
  }
}
