import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/account_model/account_model.dart';

class AccountPreference {
  AccountPreference._internal();
  static final AccountPreference _singleton = AccountPreference._internal();
  static AccountPreference get singleton => _singleton;

  final logger = Logger();
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
            usageHistory: []
        );
      }
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  Future<void> updateAccountInfo(AccountModel info, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> json = info.toJson();
    String stringJson = jsonEncode(json);
    pref.setString("accountInfo$id", stringJson);
  }

  Future<List<AccountModel>> getAllAccountData(int planLang)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<AccountModel> list = [];
    for(var i=0; i < planLang ; i ++){
      String? stringJson = pref.getString("accountInfo$i");
      if(stringJson != null) {
        Map<String, dynamic> json = jsonDecode(stringJson);
        AccountModel accountInfo = AccountModel.fromJson(json);
        list.add(accountInfo);
      }
      else{
        list.add(AccountModel(
            totalExchangeAccount: 0,
            exchange: 0,
            card: 0,
            cash: 0,
            totalUseAccount: 0,
            usageHistory: []
        ));
      }
    }
    return list;
  }

  Future<void> removeAllData(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("accountInfo$id");
  }
}