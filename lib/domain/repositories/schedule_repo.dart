import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';

import '../../data/models/schedule_model/schedule_data_model.dart';
import '../../data/models/schedule_model/schedule_model.dart';

mixin ScheduleRepo{
  Future<List<ScheduleListModel>> getScheduleList(String planId);
  Future<List<ScheduleListModel>> createSchedule(ScheduleModel item, int roundIdx, String planId);
  Future<List<ScheduleListModel>> editSchedule(ScheduleModel item, int roundIdx, String planId);
  Future<List<ScheduleListModel>> removeSchedule(int roundIdx, int itemIdx, String planId);
  Future<List<ScheduleListModel>> removeScheduleList(String planId);
  Future<List<ScheduleListModel>> addScheduleDetails(List<String> details, int roundIdx, int scheduleIdx, String planId);
  Future<List<ScheduleListModel>> removeScheduleDetail(int roundIdx, int scheduleIdx, int detailIdx, String planId);
  Future<void> removeAllScheduleList(String planId);
}