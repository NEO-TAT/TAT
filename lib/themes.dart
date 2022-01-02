// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_login/flutter_login.dart';

class TATThemes {
  static const tatBlue = Color(0xFF2f57f1);
  static const tatGray = Color(0xFF2F2F2F);
  static const tatRed = Color(0xFFD92027);
  static const tatOrange = Color(0xFFFF9234);
  static const tatWhite = Colors.white;
  static const tatDarkBlue = Color(0xFF0a1e48);
  static const tatDarkPurple = Color(0xFF120136);
  static const tatLightBlueGreen = Color(0xFF93FFD8);
  static const tatLightBluePurple = Color(0xFF548CFF);
  static const tatPurple = Color(0xFF7900FF);
  static const tatFatGreen = Color(0xFF00AF91);
  static const tatDarkFatGreen = Color(0xFF007965);
  static const tatDeepOrange = Color(0xFFF58634);
  static const tatYellow = Color(0xFFFFCC29);

  static const tatFontFamily = 'TATFont';

  static ThemeData createAppThemeData(BuildContext context) => ThemeData(
        primaryColor: tatBlue,
        primaryColorLight: tatBlue,
        primaryColorDark: tatDarkBlue,
        primaryColorBrightness: Brightness.light,
        fontFamily: tatFontFamily,
      );

  static LoginTheme get loginPageTheme => LoginTheme(
        pageColorLight: tatFatGreen,
        pageColorDark: tatDarkFatGreen,
        buttonTheme: const LoginButtonTheme(
          backgroundColor: tatDeepOrange,
          highlightColor: tatYellow,
          splashColor: tatOrange,
        ),
        titleStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        footerBottomPadding: 48,
      );
}
