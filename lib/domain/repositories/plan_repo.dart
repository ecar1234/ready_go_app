import '../../data/models/plan_model/plan_model.dart';

mixin PlanRepo {
  Future<List<PlanModel>> getLocalList();
  Future<List<PlanModel>> addToPlanList(PlanModel plan);
  Future<List<PlanModel>> changePlan(PlanModel plan);
  Future<List<PlanModel>> removePlan(int id);
}
