import 'package:flutter/material.dart';
import 'package:habit_modification/themes/dark_mode.dart';
import 'package:habit_modification/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightmode;
  ThemeData get themedata => _themeData;
  bool get isDarkMode => _themeData == darkmode;
  set themedata(ThemeData t) {
    _themeData = t;
    notifyListeners();
  }

  void toggletheme() =>
      themedata = _themeData == lightmode ? darkmode : lightmode;
}
