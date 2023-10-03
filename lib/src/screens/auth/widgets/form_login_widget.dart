import 'package:chat_hive/src/screens/auth/widgets/form_custom_widget.dart';
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