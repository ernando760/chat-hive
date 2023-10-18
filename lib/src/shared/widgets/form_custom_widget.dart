import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
import 'package:flutter/material.dart';

class FormCustomWidget extends StatelessWidget {
  const FormCustomWidget({
    super.key,
    required this.textFormFieldCustoms,
    required this.actions,
  });
  final List<TextFormFieldCustomWidget> textFormFieldCustoms;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
