import 'package:flutter/material.dart';

Widget appBar(BuildContext context, String text) {
  return AppBar(
    centerTitle: true,
    title: Text(text,
        style: TextStyle(
            fontFamily: 'Sans-serif',
            color: Colors.white,
            fontWeight: FontWeight.bold)),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF304FFE))),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle textFieldStyle(){
    return TextStyle(
      color:Colors.white,
      fontSize: 17,
      fontFamily: 'sans-serif',
    );
}