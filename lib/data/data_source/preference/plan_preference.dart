import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/plan_model/plan_model.dart';

class PlanPreference {
  PlanPreference._internal();
  static final PlanPreference _singleton = PlanPreference._internal();
  static PlanPreference get singleton => _singleton;

  // plan provider
  Future<List<PlanModel>> getPlanList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? jsonString = pref.getString("planList");
      if(jsonString != null){
        List<dynamic> jsonList = jsonDecode(jsonString);
        List<PlanModel> list = jsonList.map((plan) => PlanModel.fromJson(plan)).toList();
        return list;
      }else{
        return [];
      }
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updatePlanList(List<PlanModel> list)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      List<Map<String, dynamic>> jsonList = list.map((plan) => plan.toJson()).toList();
      String? json = jsonEncode(jsonList);
      pref.setString("planList", json);
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
  }

}