import 'package:flutter/material.dart';

class CustomStyle {
  static InputDecoration getTextFieldDecoration(String text, {double? padding}) {
    return InputDecoration(
      hintText: text,
      fillColor: const Color(0XFFF5F5F5),
      filled: true,
      enabledBorder:const  OutlineInputBorder(
        borderSide: BorderSide(
          width: 0,
          color: Color(0XFFF5F5F5),
        ), //<-- SEE HERE
      ),
      focusedBorder:const  OutlineInputBorder(
        //<-- SEE HERE
        borderSide: BorderSide(
          width: 0,
          color: Color(0XFFF5F5F5),
        ),
      ),
      contentPadding: EdgeInsets.all(padding ?? 10)
    );
  }
}
