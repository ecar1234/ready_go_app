import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/plan_model/plan_model.dart';

class PlanPreference {
  PlanPreference._internal();
  static final PlanPreference _singleton = PlanPreference._internal();
  static PlanPreference get singleton => _singleton;
  final logger = Logger();

  Future<List<PlanModel>> getPlanList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? jsonString = pref.getString("planList");
      if (jsonString != null) {
        List<dynamic> jsonList = jsonDecode(jsonString);
        List<PlanModel> list = jsonList.map((plan) => PlanModel.fromJson(plan)).toList();
        return list;
      } else {
        return [];
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> updatePlanList(List<PlanModel> list) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      List<Map<String, dynamic>> jsonList =
          list.map((plan) => plan.toJson()).toList();
      String? json = jsonEncode(jsonList);
      pref.setString("planList", json);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> planDataMigration(int oldId, String newId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final keysToMigrate = [
        'accommodation',
        'accountInfo',
        'expectation',
        'departureImg',
        'arrivalImg',
        'roaming',
        'scheduleList',
        'supplies'
      ];

      for (var key in keysToMigrate) {
        String? data = pref.getString("$key$oldId");
        if (data != null) {
          await pref.setString("$key$newId", data);
          await pref.remove("$key$oldId");
        }
      }
      logger.i("pref : planID $oldId => $newId 마이그레이션 완료");
    } on Exception catch (e) {
      logger.e("migration error : ${e.toString()}");
      rethrow;
    }
  }

  Future<int> getPlanIdMigratedVer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("migrated_version") ?? 1;
  }

  Future<void> updatePlanMigratedVer(int ver) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("migrated_version", ver);
    logger.i("migrated version update: ver $ver");
  }
}
