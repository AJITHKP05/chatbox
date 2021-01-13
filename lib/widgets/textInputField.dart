import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String) validate;

  CommonTextField({Key key, this.hint, this.controller, this.validate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validate,
      decoration: InputDecoration(
          hintText: hint,
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber))),
    );
  }
}
