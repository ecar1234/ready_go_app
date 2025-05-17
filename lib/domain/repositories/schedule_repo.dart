import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';

import '../../data/models/schedule_model/schedule_data_model.dart';
import '../../data/models/schedule_model/schedule_model.dart';

mixin ScheduleRepo{
  Future<ScheduleDataModel> getScheduleList(int planId);
  Future<ScheduleDataModel> createSchedule(ScheduleListModel item, int roundIdx, int planId);
  Future<ScheduleDataModel> editSchedule(ScheduleModel item, int roundIdx, int listIdx, int itemIdx, int planId);
  Future<ScheduleDataModel> removeSchedule(ScheduleModel item, int roundIdx, int listIdx, int itemIdx, int planId);
  Future<ScheduleDataModel> removeScheduleList(int planId);
  Future<void> removeAllScheduleList(int planId);
}