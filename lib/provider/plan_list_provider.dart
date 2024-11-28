
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/use_cases/plan_data_use_case.dart';

import '../data/models/plan_model.dart';

class PlanListProvider with ChangeNotifier, DiagnosticableTreeMixin{
  List<PlanModel> _planList =[];

  List<PlanModel> get planList => _planList;

  Future<void> setPlanEntity()async{
    var planList = await GetIt.I.get<PlanDataUseCase>().getLocalList();
    _planList = planList;
    notifyListeners();
  }
  Future<void> addPlanList(PlanModel plan)async{
    _planList.add(plan);
    await GetIt.I.get<PlanDataUseCase>().addToPlanList(plan);
    if(kDebugMode){
      print("add planList: $_planList");
    }
    notifyListeners();
  }
  Future<void> removePlanList(int id) async {
    _planList.removeWhere((plan) => plan.id == id);
    await GetIt.I.get<PlanDataUseCase>().removePlan(id);
    notifyListeners();
  }
}