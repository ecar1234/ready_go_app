import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:ready_go_project/data/repositories/schedule_local_data_repo.dart';
import 'package:ready_go_project/domain/repositories/schedule_repo.dart';

import '../../data/models/schedule_model/schedule_data_model.dart';

final _getIt = GetIt.I.get<ScheduleLocalDataRepo>();

class ScheduleDataUseCase with ScheduleRepo {
  @override
  Future<ScheduleDataModel> getScheduleList(int planId) {
    final data = _getIt.getScheduleList(planId);
    return data;
  }

  @override
  Future<ScheduleDataModel> createSchedule(ScheduleListModel item, int roundIdx, int planId) async {
    ScheduleDataModel data = await _getIt.getScheduleList(planId);
    if (data.roundData![roundIdx] == null) {
      data.roundData![roundIdx] = [];
      data.roundData![roundIdx]!.add(item);
    } else {
      data.roundData![roundIdx]!.add(item);
    }
    await _getIt.updateScheduleList(data, planId);
    return data;
  }

  @override
  Future<ScheduleDataModel> editSchedule(ScheduleModel item, int roundIdx, int listIdx, int itemIdx, int planId) async {
    ScheduleDataModel data = await _getIt.getScheduleList(planId);
    data.roundData![roundIdx]![listIdx].scheduleList![itemIdx] = item;
    await _getIt.updateScheduleList(data, planId);
    return data;
  }

  @override
  Future<ScheduleDataModel> removeSchedule(ScheduleModel item, int roundIdx, int listIdx, int itemIdx, int planId) async {
    ScheduleDataModel data = await _getIt.getScheduleList(planId);
    data.roundData![roundIdx]![listIdx].scheduleList!.removeAt(itemIdx);
    await _getIt.updateScheduleList(data, planId);
    return data;
  }

  @override
  Future<ScheduleDataModel> removeScheduleList(int planId) async {
    // TODO: implement removeScheduleList
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllScheduleList(int planId) async {
    await _getIt.removeAllScheduleData(planId);
  }
}
