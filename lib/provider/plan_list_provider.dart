import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/use_cases/plan_use_case.dart';

import '../data/models/plan_model/plan_model.dart';


class PlanListProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;

  List<PlanModel> _planList = [];

  List<PlanModel> get planList => _planList;

  Future<void> getPlanList() async {
    try {
      var list = await _getIt.get<PlanUseCase>().getLocalList();
      _planList = list;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addPlanList(PlanModel plan) async {
    try {
      var list = await _getIt.get<PlanUseCase>().addToPlanList(plan);
      _planList = list;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removePlanList(int id) async {
    try {
      var list = await _getIt.get<PlanUseCase>().removePlan(id);
      _planList = list;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
    notifyListeners();
  }
}
