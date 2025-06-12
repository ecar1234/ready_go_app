
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';
import 'package:ready_go_project/util/statistics_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../data/repositories/plan_local_data_repo.dart';
import '../../util/nation_currency_unit_util.dart';

class PlanUseCase with PlanRepo{
  final GetIt _getIt = GetIt.I;
  final logger = Logger();

  @override
  Future<List<PlanModel>> getLocalList() async {
    List<PlanModel> list = await _getIt.get<PlanLocalDataRepo>().getLocalList();
    try {
      for (var item in list) {
        if(item.nation!.isNotEmpty){
          if(item.subject == null || item.subject!.isEmpty){
            item.subject = item.nation;
            item.nation = "기타";
          }
        }
        item.unit ??= NationCurrencyUnitUtil.getNationCurrency(item.nation!);
      }
      _getIt.get<PlanLocalDataRepo>().updatePlanList(list);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    // List<PlanModel> favorite = list.where((item) => item.favorites == true).toList();
    // _getIt.get<PlanFavoritesProvider>().setFavoriteList(favorite);

    return list;
  }

  @override
  Future<List<PlanModel>> addToPlanList(PlanModel plan) async {
    List<PlanModel> list = [];
    try {
      list = await _getIt.get<PlanLocalDataRepo>().getLocalList();
      list.add(plan);
      list.sort((a, b) => a.schedule![0]!.compareTo(b.schedule![0]!));
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
      list.sort((a, b) => a.schedule![0]!.compareTo(b.schedule![0]!));

      List<PlanModel> favorite = list.where((item) => item.favorites == true).toList();
      _getIt.get<PlanFavoritesProvider>().setFavoriteList(favorite);

      await _getIt.get<PlanLocalDataRepo>().updatePlanList(list);
      return list;

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
      list.sort((a, b) => a.schedule![0]!.compareTo(b.schedule![0]!));

      // List<PlanModel> favorite = list.where((item) => item.favorites == true).toList();
      // _getIt.get<PlanFavoritesProvider>().setFavoriteList(favorite);

      await _getIt.get<PlanLocalDataRepo>().updatePlanList(list);

    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    return list;
  }
}
