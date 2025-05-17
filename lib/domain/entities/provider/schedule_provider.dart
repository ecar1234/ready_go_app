
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_data_model.dart';
import 'package:ready_go_project/domain/repositories/schedule_repo.dart';

final _getIt = GetIt.I.get<ScheduleRepo>();

class ScheduleProvider with ChangeNotifier {
  ScheduleDataModel? _scheduleList;
  ScheduleDataModel? get scheduleList => _scheduleList;

  Future<void> getScheduleList(int planId)async{
    final data = await _getIt.getScheduleList(planId);
    _scheduleList = data;
    notifyListeners();
  }
}