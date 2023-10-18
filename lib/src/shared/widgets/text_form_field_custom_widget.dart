import 'package:flutter/material.dart';

class TextFormFieldCustomWidget extends StatelessWidget {
  const TextFormFieldCustomWidget(
      {super.key,
      required this.label,
      required this.controller,
      this.keyboardType,
      this.validator,
      this.isObscure,
      this.showPassword,
      this.padding});
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscure;
  final String? Function(String?)? validator;
  final void Function()? showPassword;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        decoration: InputDecoration(
            label: Text(label),
            prefixIcon: isObscure != null
                ? isObscure!
                    ? IconButton(
                        onPressed: showPassword,
                        icon: const Icon(Icons.remove_red_eye_rounded))
                    : IconButton(
                        onPressed: showPassword,
                        icon: const Icon(Icons.visibility_off_outlined))
                : null),
        keyboardType: keyboardType,
        obscureText: isObscure ?? false,
        validator: validator,
      ),
    );
  }
}
