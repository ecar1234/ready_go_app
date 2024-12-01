

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/accommodation_model/accommodation_model.dart';

class AccommodationPreference {
  AccommodationPreference._internal();
  static final AccommodationPreference  _singleton = AccommodationPreference._internal();
  static AccommodationPreference get singleton => _singleton;

  Future<List<AccommodationModel>> getAccommodationList(int id)async{
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
      print(ex.toString());
      rethrow;
    }
  }

  Future<void> updateAccommodationList(List<AccommodationModel> list, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      List<Map<String, dynamic>> jsonList = list.map((item) => item.toJson()).toList();
      String? json = jsonEncode(jsonList);
      pref.setString("accommodation$id", json);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }

  Future<void> removeAllData(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("accommodation$id");
  }
}


