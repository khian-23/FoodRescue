import 'package:flutter/material.dart';

import '../../controllers/login/login_controller.dart';
import '../../navigation/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth/auth_error_text.dart';
import '../../widgets/auth/auth_screen_frame.dart';
import '../../widgets/auth/auth_submit_button.dart';
import '../../widgets/auth/email_form_field.dart';
import '../../widgets/auth/password_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginController = LoginController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final appUser = await _loginController.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      AppRoutes.goToDashboardForRole(context, appUser);
    } on AppAuthException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = e.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToRegister() {
    AppRoutes.goToRegister(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenFrame(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue helping the network.',
      backgroundImage:
          'assets/images/free-photo-of-waiter-serving-crispy-fried-chicken-in-restaurant.webp',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EmailFormField(controller: _emailController),
            const SizedBox(height: 12),
            PasswordFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter your password',
              obscureText: _obscurePassword,
              onToggle: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              validator: (_) => (_passwordController.text.trim().isEmpty)
                  ? 'Password is required.'
                  : null,
            ),
            const SizedBox(height: 12),
            AuthErrorText(message: _errorMessage),
            const SizedBox(height: 8),
            AuthSubmitButton(
              label: 'Login',
              isLoading: _isLoading,
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _isLoading ? null : _goToRegister,
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
