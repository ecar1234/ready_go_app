

import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/accommodation_model/accommodation_model.dart';

class AccommodationPreference {
  AccommodationPreference._internal();
  static final AccommodationPreference  _singleton = AccommodationPreference._internal();
  static AccommodationPreference get singleton => _singleton;
  final logger = Logger();

  Future<List<AccommodationModel>> getAccommodationList(String id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      String? stringJson = pref.getString("accommodation$id");
      if(stringJson != null){
        List<dynamic> json = jsonDecode(stringJson);
        List<AccommodationModel> list = json.map((item) => AccommodationModel.fromJson(item)).toList();
        return list;
      }else{
        return [];
      }
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  Future<void> updateAccommodationList(List<AccommodationModel> list, String id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      List<Map<String, dynamic>> jsonList = list.map((item) => item.toJson()).toList();
      String? json = jsonEncode(jsonList);
      pref.setString("accommodation$id", json);
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  Future<void> removeAllData(String id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("accommodation$id");
  }
}


