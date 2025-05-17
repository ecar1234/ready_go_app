
import 'package:ready_go_project/data/models/schedule_model/schedule_data_model.dart';

mixin ScheduleLocalDataRepo {
  Future<ScheduleDataModel> getScheduleList(int planId);
  Future<void> updateScheduleList(ScheduleDataModel data, int planId);
  Future<void> removeAllScheduleData(int planId);
}