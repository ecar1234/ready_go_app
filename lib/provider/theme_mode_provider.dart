import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/data_source/preference/dark_mode_preference.dart';

class ThemeModeProvider with ChangeNotifier {
  DarkModePreference get pref => DarkModePreference.singleton;

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  Future<void> getThemeMode()async{
    bool? mode = await pref.getModeState();
    if(mode != null){
      _isDarkMode = mode;
    }else{
      if(ThemeMode.system == ThemeMode.light){
        _isDarkMode = false;
      }else if(ThemeMode.system == ThemeMode.dark) {
        _isDarkMode = true;
      }
    }
    notifyListeners();
  }
  Future<void> changedThemeMode(bool mode)async{
    await pref.setMode(mode);
    _isDarkMode = mode;
    notifyListeners();
  }
}