
import 'dart:convert';

import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuppliesTempPreference {
  SuppliesTempPreference._internal();

  static final SuppliesTempPreference _singleton = SuppliesTempPreference._internal();

  static SuppliesTempPreference get singleton => _singleton;

  Future<List<TemplateModel>> getTempList()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? jsonStr = pref.getString("supplyTemplate");
    if(jsonStr != null){
      List<dynamic> json = jsonDecode(jsonStr);
      final list = json.map((item) => TemplateModel.fromJson(item)).toList();
      return list;
    }

    return [];
  }

  Future<void> setTempList(List<TemplateModel> list)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> json = list.map((item) => item.toJson()).toList();
    String strJson = jsonEncode(json);
    pref.setString("supplyTemplate", strJson);
  }
}