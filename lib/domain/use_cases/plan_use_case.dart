
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../data/repositories/plan_local_data_repo.dart';

class PlanUseCase with PlanRepo{
  final GetIt _getIt = GetIt.I;
  final logger = Logger();

  @override
  Future<List<PlanModel>> getLocalList() async {
    var list = await _getIt.get<PlanLocalDataRepo>().getLocalList();
    return list;
  }

  @override
  Future<List<PlanModel>> addToPlanList(PlanModel plan) async {
    List<PlanModel> list = [];
    try {
      list = await _getIt.get<PlanLocalDataRepo>().getLocalList();
      list.add(plan);
      await _getIt.get<PlanLocalDataRepo>().updatePlanList(list);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    return list;
  }

  @override
  Future<List<PlanModel>> changePlan(PlanModel plan) async {
    List<PlanModel> list = [];

    try {
      list = await _getIt.get<PlanLocalDataRepo>().getLocalList();
      int index = list.indexWhere((item) => item.id == plan.id);
      list[index] = plan;
      await _getIt.get<PlanLocalDataRepo>().updatePlanList(list);

    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    return list;
  }

  @override
  Future<List<PlanModel>> removePlan(int id) async {
    List<PlanModel> list = [];

    try {
      list = await _getIt.get<PlanLocalDataRepo>().getLocalList();
      list.removeWhere((plan) => plan.id == id);
      await _getIt.get<PlanLocalDataRepo>().updatePlanList(list);

    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    return list;
  }
}
