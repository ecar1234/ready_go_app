
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';


import '../../../data/models/plan_model/plan_model.dart';


class PlanListProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();

  List<PlanModel> _planList = [];

  List<PlanModel> get planList => _planList;

  Future<void> getPlanList() async {
    try {
      var list = await _getIt.get<PlanRepo>().getLocalList();
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addPlanList(PlanModel plan) async {
    try {
      var list = await _getIt.get<PlanRepo>().addToPlanList(plan);
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }
  Future<void> changePlan(PlanModel plan) async {
    try {
      var list = await _getIt.get<PlanRepo>().changePlan(plan);
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removePlanList(int id) async {
    try {
      var list = await _getIt.get<PlanRepo>().removePlan(id);
      _planList = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addFavoriteList(PlanModel plan)async{
    _getIt.get<PlanRepo>().changePlan(plan);
  }
}
