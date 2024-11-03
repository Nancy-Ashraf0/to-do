import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/utils/app_colors.dart';

class ThemeProvider extends ChangeNotifier {
  String currentMode = "light";
  bool isDark = false;
  bool get isDarkMode => isDark;

  ThemeProvider() {
    getPrefs();
  }

  Future<void> toggle(bool dark) async {
    isDark = dark;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isDark", isDark);
  }

  Future<void> getPrefs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    isDark = sharedPreferences.getBool("isDark") ?? isDark;
    notifyListeners();
  }

  Color get containerBackGround =>
      isDark ? AppColors.darkShadeBlue : AppColors.white;

  Color get borderSide => isDark ? AppColors.darkShadeBlue : AppColors.white;

  Color get dropDownColor => isDark ? AppColors.darkShadeBlue : AppColors.white;

  Color get easyDayPropsDayColor =>
      isDark ? AppColors.darkShadeBlue : AppColors.white;

  Color get splashBg => isDark ? AppColors.darkBlue : AppColors.background;

  Color get dayNumColor => isDark ? AppColors.white : AppColors.black;
}
