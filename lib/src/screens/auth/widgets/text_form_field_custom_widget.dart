import 'package:flutter/material.dart';

class TextFormFieldCustomWidget extends StatelessWidget {
  const TextFormFieldCustomWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.keyboardType,
      this.validator,
      this.padding});
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool isObscure = false;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            label: Text(label), border: const OutlineInputBorder()),
        keyboardType: keyboardType,
        obscureText: isObscure,
        validator: validator,
      ),
    );
  }
}
