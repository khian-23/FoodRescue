class FormValidators {
  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? requiredEmail(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Email is required.';
    }
    if (!_emailRegex.hasMatch(input)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? requiredPassword(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  static String? registerPassword(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return 'Password is required.';
    }
    if (input.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? requiredName(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Full name is required.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final input = (value ?? '').trim();
    if (input.isEmpty) {
      return 'Confirm password is required.';
    }
    if (input != password.trim()) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
