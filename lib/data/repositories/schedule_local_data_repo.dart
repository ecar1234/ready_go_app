
import '../models/schedule_model/schedule_list_model.dart';

mixin ScheduleLocalDataRepo {
  Future<List<ScheduleListModel>> getScheduleList(String planId);
  Future<void> updateScheduleList(List<ScheduleListModel> data, String planId);
  Future<void> removeAllScheduleData(String planId);
}