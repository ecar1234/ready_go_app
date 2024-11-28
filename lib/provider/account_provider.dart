import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/domain/use_cases/account_data_use_case.dart';

class AccountProvider with ChangeNotifier {
  AccountModel? _accountInfo;

  AccountModel? get accountInfo => _accountInfo;

  Future<void> getAccountInfo(int id)async{
    try{
      var accountInfo = await GetIt.I.get<AccountDataUseCase>().getAccountInfo(id);
      _accountInfo = accountInfo;
      notifyListeners();
      // throw Exception("get Account info failed!");
    }catch(ex){
      print("exception : ${ex.toString()}");
      rethrow;
    }

  }
  Future<void> addAmount(AmountModel amount, int day, int id)async{
    Map<int, List<AmountModel>> history = _accountInfo!.usageHistory!;

    switch(amount.category){
      case 0:
        _accountInfo!.totalUseAccount = _accountInfo!.totalUseAccount! - amount.amount!;
        _accountInfo!.exchange = _accountInfo!.exchange! + amount.amount!;
      case 1:
        _accountInfo!.cash = _accountInfo!.cash! + amount.amount!;
      case 2:
        _accountInfo!.card = _accountInfo!.card! + amount.amount!;
    }

    if(history.isEmpty){
      history[day] ??= [];
      history[day]!.add(amount);
    }else{
      if(history.containsKey(day)){
        history[day]!.add(amount);
      }else{
        history[day]??=[];
        history[day]!.add(amount);

        // print("addAmount : ${_accountInfo!.usageHistory![15]!.first}");
      }
      List<MapEntry<int, List<AmountModel>>> entry = history.entries.toList();
      entry.sort((a,b) => a.key.compareTo(b.key));
      _accountInfo!.usageHistory = Map.fromEntries(entry);
    }

    await updateAccountInfo(_accountInfo!, id);
    notifyListeners();
  }

  Future<void> addTotalAmount(int total, int id)async {
    _accountInfo!.totalExchangeAccount = _accountInfo!.totalExchangeAccount! + total;
    _accountInfo!.totalUseAccount = _accountInfo!.totalExchangeAccount! - _accountInfo!.exchange!;

    await updateAccountInfo(_accountInfo!, id);
    notifyListeners();
  }


  Future<void> updateAccountInfo(AccountModel info, int id)async{
    await GetIt.I.get<AccountDataUseCase>().updateAccountInfo(info ,id);
    notifyListeners();
  }

}