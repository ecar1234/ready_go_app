
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/domain/repositories/schedule_repo.dart';

import '../../../data/models/schedule_model/schedule_model.dart';

final _getIt = GetIt.I.get<ScheduleRepo>();

class ScheduleProvider with ChangeNotifier {
  List<ScheduleListModel>? _scheduleList;
  List<ScheduleListModel>? get scheduleList => _scheduleList;

  Future<void> getScheduleList(String planId)async{
    final data = await _getIt.getScheduleList(planId);
    _scheduleList = data;
    notifyListeners();
  }

  Future<void> createSchedule(ScheduleModel item, int roundIdx, String planId)async{
    final data = await _getIt.createSchedule(item, roundIdx ,planId);
    _scheduleList = data;
    notifyListeners();
  }

  Future<void> editSchedule(ScheduleModel item, int roundIdx, String planId)async{
    final data = await _getIt.editSchedule(item, roundIdx, planId);
    _scheduleList = data;
    notifyListeners();
  }

  Future<void> removeSchedule(int roundIdx, int itemIdx, String planId)async{
    final data = await _getIt.removeSchedule(roundIdx, itemIdx ,planId);
    _scheduleList = data;
    notifyListeners();
  }

  Future<void> addScheduleDetails(List<String> details, int roundIdx, int scheduleIdx, String planId)async{
    final data = await _getIt.addScheduleDetails(details, roundIdx, scheduleIdx, planId);
    _scheduleList = data;
    notifyListeners();
  }

  Future<void> removeScheduleDetail(int roundIdx, int scheduleIdx, int detailIdx, String planId)async{
    final data = await _getIt.removeScheduleDetail(roundIdx, scheduleIdx, detailIdx, planId);
    _scheduleList = data;
    notifyListeners();
  }

  Future<void> removeAllSchedule(String planId)async{
    await _getIt.removeAllScheduleList(planId);
    notifyListeners();
  }
}