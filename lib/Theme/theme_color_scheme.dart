import 'package:flutter/material.dart';

class ThemeColor {
  static ThemeData themeData(bool isDarkMode,BuildContext context) {
    return ThemeData(

      primarySwatch: Colors.indigo ,
      primaryColor: isDarkMode ? Colors.black : Colors.white,
      backgroundColor: isDarkMode ? Colors.black : Color(0xFFF1F5FB),
      indicatorColor: isDarkMode ? Color(0xFFCBDCF8): Color(0xFF0E1D36) ,
      buttonColor: isDarkMode ? Color(0xFF3B3B3B) : Color(0xFF133762),
      hintColor: isDarkMode ? Colors.white : Color(0xFF133762),
      highlightColor: isDarkMode ? Color(0xFF372901) : Color(0xFF133762),
      hoverColor: isDarkMode ? Color(0xFF3A3A3B) : Color(0xFF133762),
      focusColor: isDarkMode ? Color(0xFF0B2512) : Color(0xFF133762),
      disabledColor: Colors.grey,
      cardColor: isDarkMode ? Color(0xFF151515) : Colors.white,
      canvasColor: isDarkMode ? Colors.black : Colors.grey[50],
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
        colorScheme: isDarkMode ? ColorScheme.dark() : ColorScheme.light(),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}