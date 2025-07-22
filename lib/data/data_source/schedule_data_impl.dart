import 'package:ready_go_project/data/data_source/preference/schedule_preference.dart';

import '../models/schedule_model/schedule_data_model.dart';
import '../models/schedule_model/schedule_list_model.dart';
import '../repositories/schedule_local_data_repo.dart';

class ScheduleDataImpl implements ScheduleLocalDataRepo {
  SchedulePreference get pref => SchedulePreference.singleton;

  @override
  Future<List<ScheduleListModel>> getScheduleList(String planId) async {
    final list = await pref.getScheduleList(planId);
    return list;
  }

  @override
  Future<void> updateScheduleList(List<ScheduleListModel> data, String planId) async {
    await pref.updateScheduleList(data, planId);
  }

  @override
  Future<void> removeAllScheduleData(String planId) async {
    await pref.removeAllScheduleData(planId);
  }


}
