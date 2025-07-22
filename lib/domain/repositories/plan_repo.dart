import '../../data/models/plan_model/plan_model.dart';

mixin PlanRepo {
  Future<List<PlanModel>> getLocalList();
  Future<List<PlanModel>> addToPlanList(PlanModel plan);
  Future<List<PlanModel>> changePlan(PlanModel plan);
  Future<List<PlanModel>> removePlan(String id);
  Future<int> getMigratedVer();
  Future<void> updateMigratedVer(int ver);
  Future<void> planDataMigration(int oldId, String newId);
}
