import 'package:R_HabitTracker/theme/dark_mode.dart';
import 'package:R_HabitTracker/theme/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // initially lightMode.
  ThemeData _themeData = lightMode;
  // get the current theme.
  ThemeData get themeData => _themeData;
  // true if current theme is darkMode false otherwise.
  bool get isDakMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
