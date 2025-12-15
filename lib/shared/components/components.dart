import 'package:flutter/material.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  required Function() function,
  required String text,
  double raduis = 0,
}) => Container(
  width: width,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(color: Colors.white),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(raduis),
    color: background,
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmit,
  Function(String)? onChange,
  VoidCallback? onTap,
  bool isPassword = false,
  required String? Function(String?) validator,
  required String label,
  required IconData prefix,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        border: const OutlineInputBorder(),
      ),
    );


