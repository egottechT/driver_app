import 'package:flutter/material.dart';

ButtonStyle elevatedButtonStyle({Color backgroundColor = Colors.black}) =>
    ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        textStyle: TextStyle(color: Colors.white));
