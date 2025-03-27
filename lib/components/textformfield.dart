import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController Mycontroller;
  final String? Function(String?)? validator;
  const CustomTextForm(
      {super.key,
      required this.hintText,
      required this.Mycontroller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: Mycontroller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[400]),
          contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 9),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
          )),
    );
  }
}

class CustomMaterialButton extends StatelessWidget {
  final Color color;
  final String title;
  final void Function()? onPressed; // Ac
  const CustomMaterialButton(
      {super.key, required this.color, required this.title, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      textColor: Colors.white,
      color: color,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Text(title),
    );
  }
}
