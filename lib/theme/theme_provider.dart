import 'package:flutter/material.dart';
import 'package:pro3_flutter/theme/dark_mode.dart';
import 'package:pro3_flutter/theme/light_mode.dart';

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
