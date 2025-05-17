import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_data_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SchedulePreference {
  SchedulePreference._internal();
  static final SchedulePreference _singleton = SchedulePreference._internal();
  static SchedulePreference get singleton => _singleton;
  final logger = Logger();

  Future<ScheduleDataModel> getScheduleList(int planId)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? dataModel = pref.getString("scheduleList$planId");
      if(dataModel != null){
        Map<String, dynamic> data = jsonDecode(dataModel);
        final result = ScheduleDataModel.fromJson(data);
        return result;
      }else {
        return ScheduleDataModel(roundData: {});
      }
    } on Exception catch (e) {
      logger.e("pref error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> updateScheduleList(ScheduleDataModel data, int planId)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      Map<String, dynamic> json = data.toJson();
      String encodeJson = jsonEncode(json);

      pref.setString("scheduleList$planId", encodeJson);
      logger.i("Schedule list update success");
    } on Exception catch (e) {
      logger.e("pref error : ${e.toString()}");
      rethrow;
    }
  }

  Future<void> removeAllScheduleData(int planId)async{
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