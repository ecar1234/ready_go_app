import 'dart:convert';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/purchases/purchase_model.dart';

class PurchasesPreference{
  PurchasesPreference._internal();
  static final PurchasesPreference _singleton = PurchasesPreference._internal();
  static PurchasesPreference get singleton => _singleton;
  final logger = Logger();

  Future<List<PurchaseModel>> getPurchasesList()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? jsonStr = pref.getString("purchases");
      if(jsonStr != null){
        List<dynamic> jsonList = jsonDecode(jsonStr);
        List<PurchaseModel> list = jsonList.map((item) => PurchaseModel.fromJson(item)).toList();
        return list;
      }
      return [];
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }
  Future<void> updatePurchasesList(List<PurchaseModel> list)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final toJson = list.map((item) => item.toJson()).toList();
      final jsonStr = jsonEncode(toJson);
      pref.setString("purchases", jsonStr);
      logger.i("purchases save completed");
    } on Exception catch (e) {
      // TODO
      logger.e(e.toString());
      rethrow;
    }
  }
}