
import 'package:ready_go_project/data/data_source/preference/plan_preference.dart';

import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';

import '../../data/models/plan_model/plan_model.dart';

class PlanDataImpl implements PlanLocalDataRepo {
  PlanPreference get pref => PlanPreference.singleton;

  @override
  Future<List<PlanModel>> getLocalList()async {
    return await pref.getPlanList();
  }

  @override
  Future<void> updatePlanList(List<PlanModel> list)async {
    await pref.updatePlanList(list);
  }

  @override
  Future<int> getMigratedVer() async{
    return await pref.getPlanIdMigratedVer();
  }

  @override
  Future<void> updateMigratedVer(int ver)async {
    await pref.updatePlanMigratedVer(ver);
  }

  @override
  Future<void> planDataMigration(int oldId, String newId) async{
    await pref.planDataMigration(oldId, newId);
  }
}