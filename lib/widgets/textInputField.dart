import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validate;

  const CommonTextField({Key? key, this.hint, required this.controller,  
  this.validate})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validate,
      decoration: InputDecoration(
          hintText: hint,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.amber))),
    );
  }
}
