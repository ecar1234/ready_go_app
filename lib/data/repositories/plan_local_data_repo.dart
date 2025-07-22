
import '../models/plan_model/plan_model.dart';

mixin PlanLocalDataRepo {
  Future<List<PlanModel>> getLocalList();
  Future<void> updatePlanList(List<PlanModel> list);
  Future<int> getMigratedVer();
  Future<void> updateMigratedVer(int ver);
  Future<void> planDataMigration(int oldId, String newId);
}