import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/data_source/preference/preference_provider.dart';
import 'package:ready_go_project/data/models/plan_model.dart';
import 'package:ready_go_project/domain/entities/plan_list_provider.dart';
import 'package:ready_go_project/domain/repositories/plan_local_data_repo.dart';

class PlanDataUseCase implements PlanLocalDataRepo {
  PreferenceProvider get pref => PreferenceProvider.singleton;
  final GetIt _getIt = GetIt.I;

  @override
  Future<List<PlanModel>> getLocalList() async {
    List<PlanModel> list = await pref.getPlanList();
    return list;
  }

  @override
  Future<void> addToPlanList(PlanModel plan) async {
    pref.createPlan(plan);
  }

  @override
  Future<void> removePlan(int id) async {
    pref.removePlan(id);
  }


}
