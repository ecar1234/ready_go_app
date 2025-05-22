import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';
import 'package:ready_go_project/data/repositories/schedule_local_data_repo.dart';
import 'package:ready_go_project/domain/repositories/schedule_repo.dart';

final _getIt = GetIt.I.get<ScheduleLocalDataRepo>();

class ScheduleDataUseCase with ScheduleRepo {
  @override
  Future<List<ScheduleListModel>> getScheduleList(int planId) async {
    final data = await _getIt.getScheduleList(planId);
    return data;
  }

  @override
  Future<List<ScheduleListModel>> createSchedule(ScheduleModel item, int roundIdx, int planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);
    if(data.isEmpty){
      ScheduleListModel list = ScheduleListModel()..id = roundIdx..scheduleList=[];
      list.scheduleList = [];
      list.scheduleList!.add(item);
      data.add(list);
    }else{
      if(data.any((scheduleList) => scheduleList.id == roundIdx)){
        ScheduleListModel list = data.firstWhere((scheduleList) => scheduleList.id == roundIdx);
        list.scheduleList!.add(item);
        data[roundIdx] = list;
      }else{
        ScheduleListModel list = ScheduleListModel()..id=roundIdx..scheduleList=[];
        list.scheduleList!.add(item);
        data.add(list);
      }
    }
    data.sort((a, b) => a.id!.compareTo(b.id!));
    _getIt.updateScheduleList(data, planId);
    return data;
  }

  @override
  Future<List<ScheduleListModel>> editSchedule(ScheduleModel item, int roundIdx, int itemIdx, int planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);

    return data;
  }

  @override
  Future<List<ScheduleListModel>> removeSchedule(ScheduleModel item, int roundIdx, int itemIdx, int planId) async {
    List<ScheduleListModel> data = await _getIt.getScheduleList(planId);

    return data;
  }

  @override
  Future<List<ScheduleListModel>> removeScheduleList(int planId) async {
    // TODO: implement removeScheduleList
    throw UnimplementedError();
  }

  @override
  Future<void> removeAllScheduleList(int planId) async {
    await _getIt.removeAllScheduleData(planId);
  }
}
