import 'package:flutter/material.dart';
/************************************************/
Widget defaultText({
  required String text,
  double fontSize = 30,
  Color color = Colors.black,
  FontWeight fontWeight = FontWeight.normal,
}) =>
    Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
/************************************************/
Widget defaultSizedBox({
  double height = 20,
  double width = 20,
}) =>
    SizedBox(
      height: height,
      width: width,
    );
/************************************************/
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
  IconData? suffix,
  Function()? suffixPressed,
}) {
  return TextFormField(
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
      suffixIcon: suffix != null
          ? IconButton(
        icon: Icon(suffix),
        onPressed: suffixPressed,
      )
          : null,
      border: const OutlineInputBorder(),
    ),
  );
}
/************************************************/
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
/************************************************/
Widget defaultTextButton({
  required String text,
  required VoidCallback onPressed,
  Color textColor = Colors.blue,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
/************************************************/
