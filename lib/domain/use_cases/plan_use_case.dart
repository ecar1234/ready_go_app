import 'package:get_it/get_it.dart';

import 'package:ready_go_project/domain/entities/plan_entity.dart';

import '../../data/models/plan_model/plan_model.dart';

class PlanUseCase {
  final GetIt _getIt = GetIt.I;

  Future<List<PlanModel>> getLocalList() async {
    var list = await _getIt.get<PlanEntity>().getLocalList();
    return list;
  }

  Future<List<PlanModel>> addToPlanList(PlanModel plan) async {
    List<PlanModel> list = [];
    try {
      list = await _getIt.get<PlanEntity>().getLocalList();
      list.add(plan);
      await _getIt.get<PlanEntity>().updatePlanList(list);
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
    return list;
  }

  Future<List<PlanModel>> removePlan(int id) async {
    List<PlanModel> list = [];

    try {
      list = await _getIt.get<PlanEntity>().getLocalList();
      list.removeWhere((plan) => plan.id == id);
      await _getIt.get<PlanEntity>().updatePlanList(list);

    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }

    return list;
  }
}
