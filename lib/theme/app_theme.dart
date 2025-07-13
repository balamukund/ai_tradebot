import 'package:flutter/material.dart';

class AppTheme {
  // Existing color getters
  static Color getSuccessColor([bool isDark = false]) =>
      isDark ? Colors.greenAccent.shade400 : Colors.green;

  static Color getErrorColor([bool isDark = false]) =>
      isDark ? Colors.redAccent.shade200 : Colors.red;

  static Color getWarningColor([bool isDark = false]) =>
      isDark ? Colors.orangeAccent.shade200 : Colors.orange;

  static Color getAccentColor([bool isDark = false]) =>
      isDark ? Colors.cyanAccent : Colors.blueAccent;

  // Existing color constants
  static const Color successLight = Colors.green;
  static const Color errorLight = Colors.red;
  static const Color warningLight = Colors.orange;
  static const Color dividerLight = Colors.grey;
  static const Color textMediumEmphasisLight = Colors.black54;
  static const Color textHighEmphasisLight = Colors.black87;
  static const Color shadowLight = Colors.black12;

  // Add lightTheme
  static ThemeData get lightTheme => ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textHighEmphasisLight),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textHighEmphasisLight),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textHighEmphasisLight),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textHighEmphasisLight),
          bodyMedium: TextStyle(fontSize: 14, color: textMediumEmphasisLight),
          bodySmall: TextStyle(fontSize: 12, color: textMediumEmphasisLight),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textHighEmphasisLight),
          labelSmall: TextStyle(fontSize: 10, color: textMediumEmphasisLight),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: textHighEmphasisLight,
          onSurfaceVariant: textMediumEmphasisLight,
          outline: dividerLight,
          shadow: shadowLight,
          error: errorLight,
        ),
        cardColor: Colors.white,
        dividerColor: dividerLight,
        shadowColor: shadowLight,
      );

  // Add darkTheme
  static ThemeData get darkTheme => ThemeData(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: TextTheme(
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
          bodySmall: TextStyle(fontSize: 12, color: Colors.white70),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          labelSmall: TextStyle(fontSize: 10, color: Colors.white70),
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          surface: Colors.grey.shade800,
          onSurface: Colors.white,
          onSurfaceVariant: Colors.white70,
          outline: Colors.grey.shade600,
          shadow: Colors.black54,
          error: getErrorColor(true),
        ),
        cardColor: Colors.grey.shade800,
        dividerColor: Colors.grey.shade700,
        shadowColor: Colors.black54,
      );
}