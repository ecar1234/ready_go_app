import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/schedule_model/schedule_list_model.dart';

class SchedulePreference {
  SchedulePreference._internal();

  static final SchedulePreference _singleton = SchedulePreference._internal();

  static SchedulePreference get singleton => _singleton;
  final logger = Logger();

  Future<List<ScheduleListModel>> getScheduleList(int planId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? dataModel = pref.getString("scheduleList$planId");
      if (dataModel != null) {
        List<Map<String, dynamic>> jsonList = jsonDecode(dataModel);
        final data = jsonList.map((item) => ScheduleListModel.fromJson(item)).toList();
        return data;
      }else {
        return [];
      }
    } on Exception catch (e) {
      logger.e("pref error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateScheduleList(List<ScheduleListModel> data, int planId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      List<Map<String, dynamic>> jsonList = data.map((item) => item.toJson()).toList();
      String encode = jsonEncode(jsonList);
      pref.setString("scheduleList$planId", encode);
      logger.i("Schedule list update success");
    } on Exception catch (e) {
      logger.e("pref error : ${e.toString()}");
      rethrow;
    }
  }

  Future<void> removeAllScheduleData(int planId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      pref.remove("scheduleList$planId");
      logger.i("Schedule list remove success : planId => $planId}");
    } on Exception catch (e) {
      logger.e("pref error : ${e.toString()}");
      rethrow;
    }
  }
}
