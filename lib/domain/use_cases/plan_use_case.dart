
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/domain/entities/provider/plan_favorites_provider.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';

import '../../data/models/plan_model/plan_model.dart';
import '../../data/repositories/plan_local_data_repo.dart';
import '../../util/nation_currency_unit_util.dart';

final _getIt = GetIt.I.get<PlanLocalDataRepo>();
final logger = Logger();

class PlanUseCase with PlanRepo {
  @override
  Future<List<PlanModel>> getLocalList() async {
    try {
      List<PlanModel> list = await _getIt.getLocalList();
      for (var item in list) {
        if (item.nation!.isNotEmpty) {
          if (item.subject == null || item.subject!.isEmpty) {
            item.subject = item.nation;
            item.nation = "기타";
          }
        }
        item.unit ??= NationCurrencyUnitUtil.getNationCurrency(item.nation!);
      }
      await _getIt.updatePlanList(list);
      return list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<PlanModel>> addToPlanList(PlanModel plan) async {
    try {
      List<PlanModel> list = await _getIt.getLocalList();
      list.add(plan);
      list.sort((a, b) => a.schedule![0]!.compareTo(b.schedule![0]!));
      await _getIt.updatePlanList(list);
      return list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<PlanModel>> changePlan(PlanModel plan) async {
    try {
      List<PlanModel> list = await _getIt.getLocalList();
      int index = list.indexWhere((item) => item.id == plan.id);
      if (index != -1) {
        list[index] = plan;
        list.sort((a, b) => a.schedule![0]!.compareTo(b.schedule![0]!));

        List<PlanModel> favorite =
            list.where((item) => item.favorites == true).toList();
        GetIt.I.get<PlanFavoritesProvider>().setFavoriteList(favorite);

        await _getIt.updatePlanList(list);
      }
      return list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<PlanModel>> removePlan(String id) async {
    try {
      List<PlanModel> list = await _getIt.getLocalList();
      list.removeWhere((plan) => plan.id == id);
      list.sort((a, b) => a.schedule![0]!.compareTo(b.schedule![0]!));

      await _getIt.updatePlanList(list);
      return list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<int> getMigratedVer() async {
    return await _getIt.getMigratedVer();
  }

  @override
  Future<void> updateMigratedVer(int ver) async {
    await _getIt.updateMigratedVer(ver);
  }

  @override
  Future<void> planDataMigration(int oldId, String newId) async {
    await _getIt.planDataMigration(oldId, newId);
  }
}
