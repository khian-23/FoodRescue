import 'package:flutter/material.dart';

import '../../utils/form_validators.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'you@example.com',
        border: OutlineInputBorder(),
      ),
      validator: FormValidators.requiredEmail,
    );
  }
}
