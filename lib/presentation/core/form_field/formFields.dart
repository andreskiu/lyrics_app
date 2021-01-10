import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    this.onChanged,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.isPassword = false,
    this.labelText = '',
    this.hintText = '',
    this.tag = '',
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textController,
    this.textInputFormatters,
    this.maxLength,
  });
  final Function(String) onSaved;
  final Function(String) validator;
  final Function(String) onChanged;
  final String initialValue;
  final bool isPassword;
  final String labelText;
  final String hintText;
  final String tag;
  final bool enabled;
  final TextInputType keyboardType;
  final TextEditingController textController;
  final List<TextInputFormatter> textInputFormatters;
  final maxLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: textInputFormatters,
      maxLength: maxLength,
      controller: textController,
      keyboardType: keyboardType,
      enabled: enabled,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      obscureText: isPassword,
      showCursor: true,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
    );
  }
}