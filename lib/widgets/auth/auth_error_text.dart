import 'package:flutter/material.dart';

class AuthErrorText extends StatelessWidget {
  const AuthErrorText({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: message == null
          ? const SizedBox.shrink()
          : Text(
              message!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
    );
  }
}
