import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/account_model/account_model.dart';
import '../../models/account_model/amount_model.dart';

class AccountPreference {
  AccountPreference._internal();
  static final AccountPreference _singleton = AccountPreference._internal();
  static AccountPreference get singleton => _singleton;

  // account
  Future<AccountModel> getAccountInfo(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{
      String? stringJson = pref.getString("accountInfo$id");
      if(stringJson != null){
        Map<String, dynamic> json = jsonDecode(stringJson);
        AccountModel accountInfo = AccountModel.fromJson(json);
        return accountInfo;
      }else{
        return AccountModel(
            totalExchangeAccount: 0,
            exchange: 0,
            card: 0,
            cash: 0,
            totalUseAccount: 0,
            usageHistory: {}
        );
      }
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }

  Future<void> updateAccountInfo(AccountModel info, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> json = info.toJson();
    String stringJson = jsonEncode(json);
    pref.setString("accountInfo$id", stringJson);
  }

  Future<void> removeAllData(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("accountInfo$id");
  }
}