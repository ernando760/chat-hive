import 'package:chat_hive/src/shared/widgets/form_custom_widget.dart';
import 'package:flutter/material.dart';

class FormRegisterWidget extends FormCustomWidget {
  const FormRegisterWidget(
      {super.key,
      required this.formKey,
      required super.textFormFieldCustoms,
      required super.actions});
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...textFormFieldCustoms,
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: actions,
              ),
            ),
          ],
        ));
  }
}
