import 'package:chat_hive/src/shared/widgets/form_custom_widget.dart';
import 'package:flutter/material.dart';

class FormLoginWidget extends FormCustomWidget {
  const FormLoginWidget(
      {super.key,
      required this.formLoginKey,
      required super.textFormFieldCustoms,
      required super.actions});

  final GlobalKey<FormState> formLoginKey;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formLoginKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...textFormFieldCustoms,
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                children: actions,
              ),
            ),
          ],
        ));
  }
}
