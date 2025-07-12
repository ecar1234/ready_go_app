
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';


import '../../../data/models/plan_model/plan_model.dart';


  final _getIt = GetIt.I.get<PlanRepo>();
  final logger = Logger();
class PlanListProvider with ChangeNotifier {

  List<PlanModel> _planList = [];
  // int _migratedVer = 0;

  List<PlanModel> get planList => _planList;
  // int get migratedVer => _migratedVer;

  Future<void> getPlanList() async {
    try {
      // final ver = await _getIt.getMigratedVer();
      // _migratedVer = ver;
      final list = await _getIt.getLocalList();
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addPlanList(PlanModel plan) async {
    try {
      var list = await _getIt.addToPlanList(plan);
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> changePlan(PlanModel plan) async {
    try {
      var list = await _getIt.changePlan(plan);
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removePlanList(String id) async {
    try {
      var list = await _getIt.removePlan(id);
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  // Future<void> addFavoriteList(PlanModel plan)async{
  //   await _getIt.changePlan(plan);
  //   notifyListeners();
  // }
  //
  // Future<void> planDataMigration(int oldId, String newId)async{
  //   await _getIt.planDataMigration(oldId, newId);
  //   notifyListeners();
  // }
  // Future<void> updateMigratedVer(int ver)async{
  //   await _getIt.updateMigratedVer(ver);
  //   notifyListeners();
  // }
}
