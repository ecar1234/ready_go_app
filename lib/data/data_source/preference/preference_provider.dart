import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/data/models/plan_list_model.dart';
import 'package:ready_go_project/data/models/plan_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/account_model/account_model.dart';

class PreferenceProvider {
  PreferenceProvider._internal();

  static final PreferenceProvider _singleton = PreferenceProvider._internal();

  static PreferenceProvider get singleton => _singleton;

  // plan provider
  Future<List<PlanModel>> getPlanList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? jsonString = pref.getString("planList");

    if (jsonString != null) {
      Map<String, dynamic> json = jsonDecode(jsonString);
      PlanListModel list = PlanListModel.formJson(json);
      return list.planList ?? [];
    } else {
      return [];
    }
  }

  Future<void> createPlan(PlanModel plan) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<PlanModel> list = await getPlanList();
    list.add(plan);

    Map<String, dynamic> listMap = {"planList": list};

    pref.setString("planList", jsonEncode(listMap));
  }

  Future<void> removePlan(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<PlanModel> list = await getPlanList();
    list.removeWhere((e) => e.id == id);

    Map<String, dynamic> listMap = {"planList": list};

    pref.setString("planList", jsonEncode(listMap));
  }

  // Images provider
  Future<List<XFile>> getDepartImgList(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? json = pref.getString("departureImg$id");
    if(json != null){
      List<String> pathList = List<String>.from(jsonDecode(json));
      return pathList.map((path) => XFile(path)).toList();
    }else{
      return [];
    }
  }

  Future<List<XFile>> getArrivalImgList(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? json = pref.getString("arrivalImg$id");
    if(json != null){
      List<String> pathList = List<String>.from(jsonDecode(json));
      return pathList.map((path) => XFile(path)).toList();
    }else{
      return [];
    }
  }

  Future<void> addDepartureImg(XFile img, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<XFile> list = await getDepartImgList(id);
    list.add(img);

    List<String> pathList = list.map((file) => file.path).toList();
    String? json = jsonEncode(pathList);
    pref.setString("departureImg$id", json);
  }

  Future<void> addArrivalImg(XFile img, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<XFile> list = await getArrivalImgList(id);
    list.add(img);

    List<String> pathList = list.map((file) => file.path).toList();
    String? json = jsonEncode(pathList);

    pref.setString("arrivalImg$id", json);
  }

  Future<void> removeDepartureImg(XFile img, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<XFile> list = await getDepartImgList(id);

    list.removeWhere((e) => e.path == img.path);

    List<String> pathList = list.map((file) => file.path).toList();

    String? json = jsonEncode(pathList);
    pref.setString("departureImg$id", json);
  }

  Future<void> removeArrivalImg(XFile img, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<XFile> list = await getArrivalImgList(id);

    list.removeWhere((e) => e.path == img.path);

    List<String> pathList = list.map((file) => file.path).toList();

    String? json = jsonEncode(pathList);
    pref.setString("arrivalImg$id", json);
  }

  //supplies
  Future<List<Map<String, bool>>> getSuppliesList(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = pref.getString("supplies$id");
    List<Map<String, bool>> boolList = [];

    if(json != null){
      List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonDecode(json));
      for(var item in list){
        Map<String, bool> boolChange = item.map((key, value) => MapEntry(key, value as bool));
        boolList.add(boolChange);
      }
      return boolList;

    }else {
      return [];
    }
  }

  Future<void> addSuppliesItem(List<Map<String, bool>> item, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? json = jsonEncode(item);
    pref.setString("supplies$id", json);
  }
  Future<void> removeSuppliesItem(List<Map<String, bool>> item, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? json = jsonEncode(item);
    pref.setString("supplies$id", json);
  }
  Future<void> updateSuppliesItem(List<Map<String, bool>> item, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? json = jsonEncode(item);
    pref.setString("supplies$id", json);
  }

  // roaming
  Future<List<XFile>> getRoamingImageList(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = pref.getString("roamingImg$id");
    if(json != null){
      List<String> list = List<String>.from(jsonDecode(json));
      return list.map((path) => XFile(path)).toList();
    }else{
      return [];
    }
  }
  Future<Map<String, bool>> getRoamingAddress(int id) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = pref.getString("address$id");
    if(json != null){
      Map<String, dynamic> decodeJson = jsonDecode(json);
      Map<String, bool> result = decodeJson.map((key, value) => MapEntry(key, value as bool));
      return result;
    }else{
      return {};
    }
  }
  Future<Map<String, bool>> getRoamingCode(int id) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = pref.getString("code$id");
    if(json != null){
      Map<String, dynamic> decodeJson = jsonDecode(json);
      Map<String, bool> result = decodeJson.map((key, value) => MapEntry(key, value as bool));
      return result;
    }else {
      return {};
    }
  }
  Future<Map<String, dynamic>> getRoamingPeriod(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = pref.getString("roamingPeriod$id");
    if(json != null){
      Map<String, dynamic> period = jsonDecode(json);
      period["startDate"] = DateTime.parse(period["startDate"]);
      period["endDate"] = DateTime.parse(period["endDate"]);
      return period;
    }else {
      return {
        "period" :0,
        "isActive": false,
        "startDate": DateTime.now(),
        "endDate": DateTime.now()
      };
    }
  }
  Future<void> updateRoamingPeriod(Map<String, dynamic> period, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> encodePeriod = period.map((key, value){
      if(value is DateTime){
        return MapEntry(key, value.toIso8601String());
      }
      return MapEntry(key, value);
    });
    String jsonPeriod = jsonEncode(encodePeriod);

    pref.setString("roamingPeriod$id", jsonPeriod);
  }

  Future<void> updateRoamingImgList(List<XFile> list, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? pathList = list.map((e) => e.path).toList();
    String? json = jsonEncode(pathList);
    pref.setString("roamingImg$id", json);
  }
  Future<void> updateRoamingAddress(Map<String, bool> addr, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = jsonEncode(addr);
    pref.setString("address$id", json);
  }
  Future<void> updateRoamingCode(Map<String, bool> code, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? json = jsonEncode(code);
    pref.setString("code$id", json);
  }
  
  // account 
  Future<AccountModel> getAccountInfo(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
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
  }
  Future<void> updateAccountInfo(AccountModel info, int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> json = info.toJson();
    String stringJson = jsonEncode(json);
    pref.setString("accountInfo$id", stringJson);
  }

  // accommodation

  Future<List<AccommodationModel>> getAccommodationList(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? stringJson = pref.getString("accommodation$id");
    if(stringJson != null){
      List<dynamic> json = jsonDecode(stringJson);
      List<AccommodationModel> list = json.map((item) => AccommodationModel.fromJson(item)).toList();
      return list;
    }else{
      return [];
    }
  }
  Future<void> updateAccommodationList(List<AccommodationModel> list, int id)async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> listJson = list.map((item) => item.toJson()).toList();
    String? stringJson = jsonEncode(listJson);
    pref.setString("accommodation$id", stringJson);
  }
}
