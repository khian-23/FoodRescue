import 'package:flutter/material.dart';

import '../../models/food_listing_model.dart';

class FoodListingFormDialog extends StatefulWidget {
  const FoodListingFormDialog({super.key, this.initialListing});

  final FoodListingModel? initialListing;

  @override
  State<FoodListingFormDialog> createState() => _FoodListingFormDialogState();
}

class _FoodListingFormDialogState extends State<FoodListingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _pickupController;
  late final TextEditingController _availableUntilController;

  @override
  void initState() {
    super.initState();
    final listing = widget.initialListing;
    _titleController = TextEditingController(text: listing?.title ?? '');
    _descriptionController =
        TextEditingController(text: listing?.description ?? '');
    _quantityController = TextEditingController(text: listing?.quantity ?? '');
    _pickupController =
        TextEditingController(text: listing?.pickupLocation ?? '');
    _availableUntilController =
        TextEditingController(text: listing?.availableUntil ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _pickupController.dispose();
    _availableUntilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialListing == null ? 'New Listing' : 'Edit Listing'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogField(controller: _titleController, label: 'Food title'),
              const SizedBox(height: 12),
              _DialogField(
                controller: _descriptionController,
                label: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _DialogField(controller: _quantityController, label: 'Quantity'),
              const SizedBox(height: 12),
              _DialogField(
                controller: _pickupController,
                label: 'Pickup location',
              ),
              const SizedBox(height: 12),
              _DialogField(
                controller: _availableUntilController,
                label: 'Available until',
                hint: 'e.g. Today 7:00 PM',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.of(context).pop({
              'title': _titleController.text.trim(),
              'description': _descriptionController.text.trim(),
              'quantity': _quantityController.text.trim(),
              'pickupLocation': _pickupController.text.trim(),
              'availableUntil': _availableUntilController.text.trim(),
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return '$label is required.';
        }
        return null;
      },
    );
  }
}
