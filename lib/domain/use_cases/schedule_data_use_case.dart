import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';
import 'package:ready_go_project/data/repositories/schedule_local_data_repo.dart';
import 'package:ready_go_project/domain/repositories/schedule_repo.dart';
import 'package:ready_go_project/util/date_util.dart';

final _getIt = GetIt.I.get<ScheduleLocalDataRepo>();
final logger = Logger();

class ScheduleDataUseCase with ScheduleRepo {
  @override
  Future<List<ScheduleListModel>> getScheduleList(String planId) async {
    try {
      final data = await _getIt.getScheduleList(planId);

      List<PlanModel> planList = await GetIt.I.get<PlanLocalDataRepo>().getLocalList();
      List<DateTime?>? startDate = planList.firstWhere((item) => item.id == planId).schedule!;
      final daysIndex = DateUtil.datesDifference(startDate);

      if (data.isEmpty) {
        for (var i = 0; i <= daysIndex; i++) {
          data.add(ScheduleListModel()
            ..id = i
            ..scheduleList = []);
        }
        await _getIt.updateScheduleList(data, planId);
      }else {
        if(data.length != daysIndex+1){
          if(data.length < daysIndex+1){
            while (data.length < daysIndex+1) {
              ScheduleListModel blank = ScheduleListModel()
                ..scheduleList = [];
              data.add(blank);
            }
          }else if(data.length > daysIndex+1){
            data.removeRange(daysIndex, data.length);
          }
          await _getIt.updateScheduleList(data, planId);
        }
      }



      return data;
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ScheduleListModel>> createSchedule(ScheduleModel item, int roundIdx, String planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);

    if (data[roundIdx].scheduleList!.isEmpty) {
      item.id = 0;
      data[roundIdx].scheduleList!.add(item);
    } else {
      item.id = data[roundIdx].scheduleList!.length;
      data[roundIdx].scheduleList!.add(item);
    }

    data[roundIdx].scheduleList!.sort((a, b) {
      TimeOfDay aTime = TimeOfDay(hour: int.parse(a.time!.split(":")[0]), minute: int.parse(a.time!.split(":")[1]));
      TimeOfDay bTime = TimeOfDay(hour: int.parse(b.time!.split(":")[0]), minute: int.parse(b.time!.split(":")[1]));
      return aTime.compareTo(bTime);
    });

    _getIt.updateScheduleList(data, planId);
    return data;
  }

  @override
  Future<List<ScheduleListModel>> editSchedule(ScheduleModel item, int roundIdx, String planId) async {
    try {
      List<ScheduleListModel> data = await _getIt.getScheduleList(planId);

      ScheduleModel oldItem = data[roundIdx].scheduleList!.firstWhere((remove) => remove.id == item.id);
      if(oldItem.details != null && oldItem.details!.isNotEmpty){
        item.details = oldItem.details;
      }
      data[roundIdx].scheduleList!.remove(oldItem);
      data[roundIdx].scheduleList!.add(item);

      data[roundIdx].scheduleList!.sort((a, b) {
        TimeOfDay aTime = TimeOfDay(hour: int.parse(a.time!.split(":")[0]), minute: int.parse(a.time!.split(":")[1]));
        TimeOfDay bTime = TimeOfDay(hour: int.parse(b.time!.split(":")[0]), minute: int.parse(b.time!.split(":")[1]));
        return aTime.compareTo(bTime);
      });

      _getIt.updateScheduleList(data, planId);
      return data;
    } on FormatException catch (e) {
      logger.e(e.toString());
      rethrow;
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ScheduleListModel>> removeSchedule(int roundIdx, int itemIdx, String planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);
    try {
      final dayScheduleList = data.firstWhere((item) => item.id == roundIdx);
      final findIndex = data.indexOf(dayScheduleList);
      data[findIndex].scheduleList!.removeAt(itemIdx);
      _getIt.updateScheduleList(data, planId);
      return data;
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ScheduleListModel>> removeScheduleList(String planId) async {
    // TODO: implement removeScheduleList
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleListModel>> addScheduleDetails(List<String> details, int roundIdx, int scheduleIdx, String planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);
    try {
      if (data[roundIdx].scheduleList![scheduleIdx].details == null) {
        data[roundIdx].scheduleList![scheduleIdx].details = [];
        data[roundIdx].scheduleList![scheduleIdx].details!.addAll(details);
      } else {
        data[roundIdx].scheduleList![scheduleIdx].details = details;
      }

      _getIt.updateScheduleList(data, planId);
      return data;
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ScheduleListModel>> removeScheduleDetail(int roundIdx, int scheduleIdx, int detailIdx, String planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);

    try {
      data[roundIdx].scheduleList![scheduleIdx].details!.removeAt(detailIdx);
      _getIt.updateScheduleList(data, planId);
      return data;
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeAllScheduleList(String planId) async {
    await _getIt.removeAllScheduleData(planId);
  }
}
