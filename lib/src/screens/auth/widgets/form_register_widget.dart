import 'package:chat_hive/src/screens/auth/widgets/form_custom_widget.dart';
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
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...textFormFieldCustoms,
              const SizedBox(height: 20),
              SizedBox(
                child: Column(
                  children: actions,
                ),
              ),
            ],
          ),
        ));
  }
}
