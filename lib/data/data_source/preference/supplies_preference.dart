import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuppliesPreference {
  SuppliesPreference._internal();

  static final SuppliesPreference _singleton = SuppliesPreference._internal();

  static SuppliesPreference get singleton => _singleton;

  final logger = Logger();
  //supplies
  Future<List<SupplyModel>> getSuppliesList(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<SupplyModel> list = [];

    try {
      String? json = pref.getString("supplies$id");
      if (json != null) {
        List<dynamic> jsonList = jsonDecode(json);
        list = jsonList.map((supply) => SupplyModel.fromJson(supply)).toList();
        return list;
      } else {
        return list;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> updateSupplyList(List<SupplyModel> list, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      List<Map<String, dynamic>> listToJson = list.map((supply) => supply.toJson()).toList();
      String? json = jsonEncode(listToJson);
      pref.setString("supplies$id", json);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> removeAllData(String id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("supplies$id");
  }
}
