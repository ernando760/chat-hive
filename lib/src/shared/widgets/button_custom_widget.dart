import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:flutter/material.dart';

class ButtonCustomWidget extends StatelessWidget {
  const ButtonCustomWidget({super.key, required this.label, this.onPressed});

  final void Function()? onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: context.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        onPressed: onPressed,
        child: Text(
          label,
          style: context.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ));
  }
}
