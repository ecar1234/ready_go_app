
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';
import 'package:ready_go_project/domain/repositories/schedule_repo.dart';

final _getIt = GetIt.I.get<ScheduleRepo>();

class ScheduleProvider with ChangeNotifier {
  List<ScheduleListModel>? _scheduleList;
  List<ScheduleListModel>? get scheduleList => _scheduleList;

  Future<void> getScheduleList(int planId)async{
    final data = await _getIt.getScheduleList(planId);
    _scheduleList = data;
    notifyListeners();
  }
}