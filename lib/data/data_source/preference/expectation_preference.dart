import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpectationPreference{
  ExpectationPreference._internal();
  static final _singleton = ExpectationPreference._internal();
  static ExpectationPreference get singleton => _singleton;
  Logger logger = Logger();

  Future<List<ExpectationModel>> getExpectationData(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? jsonStr = pref.getString("expectation$id");
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        List<dynamic>  json = jsonDecode(jsonStr);
        List<ExpectationModel> list = json.map((item) => ExpectationModel.fromJson(item)).toList();
        return list ;
      } catch (e) {
        logger.e("JSON parsing error: $e");
        return [];
      }
    } else {
      return [];
    }
  }
  Future<void> updateExpectationDate(List<ExpectationModel> list, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    final toJson = list.map((item) => item.toJson()).toList();
    String json = jsonEncode(toJson);
    pref.setString("expectation$id", json);
    logger.i("expectation data save success");
  }

  Future<void> removeAllData(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("expectation$id");
    logger.i("success expectation data remove all");
  }

}