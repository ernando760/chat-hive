import 'package:chat_hive/src/shared/widgets/form_custom_widget.dart';
import 'package:flutter/material.dart';

class FormUpdateUserWidget extends FormCustomWidget {
  const FormUpdateUserWidget(
      {super.key,
      required this.formUpdateUserKey,
      required super.textFormFieldCustoms,
      required super.actions});

  final GlobalKey<FormState> formUpdateUserKey;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formUpdateUserKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...textFormFieldCustoms,
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: actions,
              ),
            ),
          ],
        ));
  }
}
