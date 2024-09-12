import 'package:flutter/material.dart';

class CustomTextAreaFormField extends StatelessWidget {
  final String hintText;
  final String? title;
  final TextEditingController controller;
  final FormFieldValidator<String>? validators;
  final TextInputType? keyboardType;
  final bool isRequired;
  const CustomTextAreaFormField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.title,
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
            controller: controller,
            minLines: 4,
            maxLines: 8,
            keyboardType: keyboardType,
            validator: isRequired
                ? (String? value) {
                    if (value?.isEmpty == true) {
                      return 'This field is Required.';
                    }
                    return null;
                  }
                : validators,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16.0),
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
