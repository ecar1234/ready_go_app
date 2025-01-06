import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/domain/use_cases/account_use_case.dart';

GetIt _getIt = GetIt.I;
class AccountProvider with ChangeNotifier {
  AccountModel? _accountInfo;

  AccountModel? get accountInfo => _accountInfo;

  Future<void> getAccountInfo(int id)async{
    try{
      var accountInfo = await GetIt.I.get<AccountUseCase>().getAccountInfo(id);
      _accountInfo = accountInfo;
      // throw Exception("get Account info failed!");
    }catch(ex){
      log("exception : ${ex.toString()}");
      rethrow;
    }
    notifyListeners();
  }
  Future<void> addAmount(AmountModel amount, int day, int id)async{
    try{
      var account = await _getIt.get<AccountUseCase>().addAmount(amount, day, id);
      _accountInfo = account;
    }catch(ex){
      log(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addTotalAmount(int total, int day, int id)async {
   try{
     var account =  await _getIt.get<AccountUseCase>().addTotalAmount(total, day, id);
     _accountInfo = account;
   }catch(ex){
     log(ex.toString());
     rethrow;
   }

    notifyListeners();
  }
  Future<void> removeAmountItem(int firstIdx, secondIdx, int id)async{
    var account = await _getIt.get<AccountUseCase>().removeAmountItem(firstIdx, secondIdx, id);
    _accountInfo = account;
    notifyListeners();
  }
  Future<void> editeAmountItem(int firstIdx, int secondIdx, AmountModel newAmount, int id)async{
    var account = await _getIt.get<AccountUseCase>().editAmountItem(firstIdx, secondIdx, newAmount, id);
    _accountInfo = account;
    notifyListeners();
  }

  Future<void> removeAllData(int id)async{
    var account =  await _getIt.get<AccountUseCase>().removeAllData(id);
    _accountInfo = account;
    notifyListeners();
  }
}