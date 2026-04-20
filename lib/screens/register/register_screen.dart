import 'package:flutter/material.dart';

import '../../controllers/register/register_controller.dart';
import '../../navigation/app_routes.dart';
import '../../services/auth_service.dart';
import '../../utils/form_validators.dart';
import '../../widgets/auth/auth_error_text.dart';
import '../../widgets/auth/auth_screen_frame.dart';
import '../../widgets/auth/auth_submit_button.dart';
import '../../widgets/auth/email_form_field.dart';
import '../../widgets/auth/password_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _registerController = RegisterController();
  String _userType = 'donor';

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _registerController.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        userType: _userType,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful. Welcome!')),
      );

      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) {
        return;
      }

      AppRoutes.goToUserDashboard(context);
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
        _errorMessage = 'Registration failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToLogin() {
    AppRoutes.replaceWithLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenFrame(
      title: 'Create Account',
      subtitle: 'Join the network and start rescuing food responsibly.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                hintText: 'Juan dela Cruz',
                border: OutlineInputBorder(),
              ),
              validator: FormValidators.requiredName,
            ),
            const SizedBox(height: 12),
            EmailFormField(controller: _emailController),
            const SizedBox(height: 12),
            PasswordFormField(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Minimum 6 characters',
              obscureText: _obscurePassword,
              onToggle: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              validator: FormValidators.registerPassword,
            ),
            const SizedBox(height: 12),
            PasswordFormField(
              controller: _confirmPasswordController,
              label: 'Confirm password',
              hintText: 'Re-enter password',
              obscureText: _obscureConfirmPassword,
              onToggle: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              validator: (value) => FormValidators.confirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _userType,
              decoration: const InputDecoration(
                labelText: 'Account type',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'donor',
                  child: Text('Donor / Restaurant'),
                ),
                DropdownMenuItem(
                  value: 'rescuer',
                  child: Text('Rescuer / Recipient'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _userType = value ?? 'donor';
                });
              },
            ),
            const SizedBox(height: 12),
            AuthErrorText(message: _errorMessage),
            const SizedBox(height: 8),
            AuthSubmitButton(
              label: 'Register',
              isLoading: _isLoading,
              onPressed: _handleRegister,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _isLoading ? null : _goToLogin,
              child: const Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
