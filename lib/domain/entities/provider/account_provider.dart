
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';

import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';

GetIt _getIt = GetIt.I;
class AccountProvider with ChangeNotifier {
  AccountModel? _accountInfo;

  AccountModel? get accountInfo => _accountInfo;

  List<Map<String, int>>? _totalUseAccountInfo;

  List<Map<String, int>>? get totalUseAccountInfo => _totalUseAccountInfo;

  final logger = Logger();

  Future<void> getTotalUseAccountInfo()async{
    final planList = await _getIt.get<PlanRepo>().getLocalList();
    final allAccountInfo = await GetIt.I.get<AccountRepo>().getTotalUseAccountInfo(planList.length);
    Map<String, int> accountInfo = {};
    for(var i = 0; i > planList.length; i++){
      accountInfo[planList[i].nation!] = allAccountInfo[i].useExchangeMoney! + allAccountInfo[i].useCard!;
    }
    _totalUseAccountInfo = accountInfo.entries.map((e) => {e.key:e.value}).toList();

    notifyListeners();
  }

  Future<void> getAccountInfo(String id)async{
    try{
      var accountInfo = await GetIt.I.get<AccountRepo>().getAccountInfo(id);
      _accountInfo = accountInfo;
      // throw Exception("get Account info failed!");
    }catch(ex){
      logger.e("exception : ${ex.toString()}");
      rethrow;
    }
    notifyListeners();
  }
  Future<void> addAmount(AmountModel amount, int day, String id)async{
    try{
      var account = await _getIt.get<AccountRepo>().addAmount(amount, day, id);
      _accountInfo = account;
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addTotalAmount(String title, int total, int day, String id)async {
   try{
     var account =  await _getIt.get<AccountRepo>().addTotalAmount(title, total, day, id);
     _accountInfo = account;
   }catch(ex){
     logger.e(ex.toString());
     rethrow;
   }

    notifyListeners();
  }
  Future<void> removeAmountItem(int firstIdx, secondIdx, String id)async{
    var account = await _getIt.get<AccountRepo>().removeAmountItem(firstIdx, secondIdx, id);
    _accountInfo = account;
    notifyListeners();
  }
  Future<void> editeAmountItem(int firstIdx, int secondIdx, AmountModel newAmount, String id)async{
    var account = await _getIt.get<AccountRepo>().editAmountItem(firstIdx, secondIdx, newAmount, id);
    _accountInfo = account;
    notifyListeners();
  }

  Future<void> removeAllData(String id)async{
    var account =  await _getIt.get<AccountRepo>().removeAllData(id);
    _accountInfo = account;
    notifyListeners();
  }
}