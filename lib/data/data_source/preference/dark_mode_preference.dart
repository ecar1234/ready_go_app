import 'package:shared_preferences/shared_preferences.dart';

class DarkModePreference {
  DarkModePreference._internal();

  static final DarkModePreference _singleton = DarkModePreference._internal();

  static DarkModePreference get singleton => _singleton;

  Future<bool?> getModeState()async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    bool? isDark = pref.getBool("isDarkMode");

    return isDark;
  }

  Future<void> setMode(bool isDark)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("isDarkMode", isDark);
  }
}