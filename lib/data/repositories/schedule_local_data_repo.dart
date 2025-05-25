
import '../models/schedule_model/schedule_list_model.dart';

mixin ScheduleLocalDataRepo {
  Future<List<ScheduleListModel>> getScheduleList(int planId);
  Future<void> updateScheduleList(List<ScheduleListModel> data, int planId);
  Future<void> removeAllScheduleData(int planId);
}