import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController controller;
  final Widget? icon; // Optional icon widget
  final bool enabled;
  final FormFieldValidator<String>? validators;
  final TextInputType? keyboardType;
  final bool isRequired;

  const CustomTextFormField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.icon,
      this.title,
      this.enabled = true,
      this.validators,
      this.keyboardType,
      this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Text(
                title ?? '',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          TextFormField(
            enabled: enabled,
            controller: controller,
            validator: isRequired
                ? (String? value) {
                    if (value?.isEmpty == true) {
                      return 'This field is Required.';
                    }
                    return null;
                  }
                : validators,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16.0),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              suffixIcon: icon, // Add the icon here if provided
            ),
          ),
        ],
      ),
    );
  }
}
