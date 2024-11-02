import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String selectedLang = "en";

  LanguageProvider() {
    getPref();
  }

  Future<void> setLangPref(String newLang) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("lang", newLang);
    getPref();
  }

  Future<void> getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    selectedLang = sharedPreferences.getString("lang") ?? selectedLang;
    notifyListeners();
  }
}
