import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(BuildContext context, Widget screen, bool isReplacement) {
  if(isReplacement) {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => screen));}
  else {Navigator.push(context, MaterialPageRoute(builder: (context) => screen));}
}

Widget buildTextFormField({
  @required TextEditingController textEditingController,
  @required TextInputType textInputType,
  bool obscureText = false,
  Function onFieldSubmitted,
  Function onChanged,
  Function onTap,
  Function validator,
  @required String labelText,
  @required IconData prefixIcon,
  IconData suffixIcon,
  Function suffixIconPressed,
}) => TextFormField(
  controller: textEditingController,
  keyboardType: textInputType,
  obscureText: obscureText,
  onFieldSubmitted: onFieldSubmitted,
  onChanged: onChanged,
  onTap: onTap,
  validator: validator,
  decoration: InputDecoration(
    labelText: labelText,
    prefixIcon: Icon(prefixIcon),
    suffixIcon: suffixIcon != null ? IconButton(
      icon: Icon(suffixIcon),
      onPressed: suffixIconPressed,
    ) : null,
    border: const OutlineInputBorder(),
  ),
);

Widget buildButton({
  double width = double.maxFinite,
  double height = 40,
  Color background = Colors.blue,
  Color textColor = Colors.white,
  double radius = 0.0,
  @required Function onPressed,
  @required String text,
}) => ElevatedButton(
  onPressed: onPressed,
  child: Text(text, style: TextStyle(color: textColor)),
  style: ElevatedButton.styleFrom(
      primary: background,
      fixedSize: Size(width, height),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))
  ),
);

enum ToastStates {success, error, warning}

showToast({String message, ToastStates toastState}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(toastState),
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Color chooseToastColor(ToastStates toastState) {
  Color color;
  switch (toastState) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}