import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';
import 'package:ready_go_project/domain/entities/provider/plan_list_provider.dart';
import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';
import 'package:ready_go_project/domain/use_cases/account_use_case.dart';

import '../../data/models/account_model/account_model.dart';
import '../../data/models/plan_model/plan_model.dart';

class StatisticsUseCase with ChangeNotifier {
  final logger = Logger();
  List<Map<String, List<int>>>? _accounts;

  List<Map<String, List<int>>>? get accounts => _accounts;

  List<Map<String, int>>? _nations;

  List<Map<String, int>>? get nations => _nations;

  void getStatisticsData() async{
    Map<String, int> nations = {};
    Map<String, List<int>> accounts = {};

    final planList = await GetIt.I.get<PlanLocalDataRepo>().getLocalList();
    final completePlanList = planList.where((item) => item.schedule!.last!.isBefore(DateTime.now())).toList();

    try {
      for (var item in completePlanList) {
        final nation = item.nation!;
        nations[nation] = (nations[nation] ?? 0) + 1;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    try {
      for (var item in completePlanList) {
        final planAccount = await GetIt.I.get<AccountRepo>().getAccountInfo(item.id!);
        if(item.nation != null){
          List<int> useAccount = [planAccount.useExchangeMoney!, planAccount.useCard!];
          final useCash = (accounts[item.nation!] == null ?0:accounts[item.nation!]!.first) + useAccount.first;
          final useCard = (accounts[item.nation!] == null ?0:accounts[item.nation!]!.last) + useAccount.last;
          accounts[item.nation!] = [useCash, useCard];
        }else{
          accounts[item.nation!] = [0, 0];
        }
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    _accounts = accounts.entries.map((e) => {e.key: e.value}).toList();
    _nations = nations.entries.map((e) => {e.key: e.value}).toList();

    notifyListeners();
  }

  // Future<void> accountStatistics() async {
  //
  //   final planList = await GetIt.I.get<PlanRepo>().getLocalList();
  //   final completePlanList = planList.where((item) => item.schedule!.last!.isBefore(DateTime.now())).toList();
  //
  //
  //   notifyListeners();
  // }
}
