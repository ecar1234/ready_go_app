import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';

import '../../data/models/schedule_model/schedule_data_model.dart';
import '../../data/models/schedule_model/schedule_model.dart';

mixin ScheduleRepo{
  Future<List<ScheduleListModel>> getScheduleList(int planId);
  Future<List<ScheduleListModel>> createSchedule(ScheduleModel item, int roundIdx, int planId);
  Future<List<ScheduleListModel>> editSchedule(ScheduleModel item, int roundIdx, int itemIdx, int planId);
  Future<List<ScheduleListModel>> removeSchedule(ScheduleModel item, int roundIdx, int itemIdx, int planId);
  Future<List<ScheduleListModel>> removeScheduleList(int planId);
  Future<void> removeAllScheduleList(int planId);
}