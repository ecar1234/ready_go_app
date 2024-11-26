import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/models/plan_model.dart';

mixin PlanLocalDataRepo {
  Future<List<PlanModel>> getLocalList();
  Future<void> addToPlanList(PlanModel plan);
  Future<void> removePlan(int id);
}