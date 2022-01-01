// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class TATTheme {
  static const Color tatBlue = Color(0xFF2f57f1);
  static const Color tatGray = Color(0xFF2F2F2F);
  static const Color tatWhite = Colors.white;
  static const Color tatDarkBlue = Color(0xFF0a1e48);

  static ThemeData createAppThemeData(BuildContext context) => ThemeData(
        primaryColor: tatBlue,
        primaryColorLight: tatBlue,
        primaryColorDark: tatDarkBlue,
        primaryColorBrightness: Brightness.light,
      );
}
