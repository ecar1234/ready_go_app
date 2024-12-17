
import '../../data/models/plan_model/plan_model.dart';

mixin PlanLocalDataRepo {
  Future<List<PlanModel>> getLocalList();
  Future<void> updatePlanList(List<PlanModel> list);
}