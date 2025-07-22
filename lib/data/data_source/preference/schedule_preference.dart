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

  Future<List<ScheduleListModel>> getScheduleList(String planId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? dataModel = pref.getString("scheduleList$planId");
      if (dataModel != null) {
        final jsonList = jsonDecode(dataModel);
        if (jsonList is List) {
          final data = jsonList
              .map((item) => ScheduleListModel.fromJson(item as Map<String,dynamic>))
              .toList();
          return data;
        }else {
          return [];
        }
      }else {
        return [];
      }
    } on Exception catch (e) {
      logger.e("pref error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateScheduleList(List<ScheduleListModel> data, String planId) async {
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

  Future<void> removeAllScheduleData(String planId) async {
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
