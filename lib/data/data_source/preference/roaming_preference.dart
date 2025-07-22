import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoamingPreference {
  RoamingPreference._internal();

  static final RoamingPreference _singleton = RoamingPreference._internal();

  static RoamingPreference get singleton => _singleton;

  final logger = Logger();
  // roaming

  Future<RoamingModel?> getRoamingData(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? json = pref.getString("roaming$id");
      if (json != null) {
        Map<String, dynamic> stringData = jsonDecode(json);
        RoamingModel data = RoamingModel.fromJson(stringData);
        return data;
      } else {
        return null;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> setRoamingData(RoamingModel data, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      Map<String, dynamic> dataJson = data.toJson();
      String? json = jsonEncode(dataJson);
      pref.setString("roaming$id", json);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  // Future<List<XFile>> getRoamingImageList(int id) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //
  //   try {
  //     List<XFile> list = [];
  //     String? json = pref.getString("roaming$id");
  //     if (json != null) {
  //       Map<String, dynamic> stringData = jsonDecode(json);
  //       RoamingModel data = RoamingModel.fromJson(stringData);
  //       if (data.imgList!.isEmpty) {
  //         return list;
  //       } else {
  //         list = data.imgList!.map((path) => XFile(path)).toList();
  //         return list;
  //       }
  //     } else {
  //       return list;
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
  //
  // Future<String> getRoamingAddress(int id) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String addr = "";
  //
  //   try {
  //     String? json = pref.getString("roaming$id");
  //     if (json != null) {
  //       Map<String, dynamic> stringData = jsonDecode(json);
  //       RoamingModel data = RoamingModel.fromJson(stringData);
  //       if (data.dpAddress!.isEmpty) {
  //         return addr;
  //       } else {
  //         addr = data.dpAddress!;
  //         return addr;
  //       }
  //     } else {
  //       return addr;
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
  //
  // Future<String> getRoamingCode(int id) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //
  //   String code = "";
  //
  //   try {
  //     String? json = pref.getString("roaming$id");
  //     if (json != null) {
  //       Map<String, dynamic> stringData = jsonDecode(json);
  //       RoamingModel data = RoamingModel.fromJson(stringData);
  //       if (data.dpAddress!.isEmpty) {
  //         return code;
  //       } else {
  //         code = data.dpAddress!;
  //         return code;
  //       }
  //     } else {
  //       return code;
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }
  //
  // Future<RoamingPeriodModel> getRoamingPeriod(int id) async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //
  //   RoamingPeriodModel period = RoamingPeriodModel();
  //
  //   try {
  //     String? json = pref.getString("roaming$id");
  //     if (json != null) {
  //       Map<String, dynamic> stringData = jsonDecode(json);
  //       RoamingModel data = RoamingModel.fromJson(stringData);
  //       if (data.period == null) {
  //         return period;
  //       } else {
  //         period = data.period!;
  //         return period;
  //       }
  //     } else {
  //       return period;
  //     }
  //   } on Exception catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  // image 저장 후 종료, 값을 리턴 하지 않고, 이미지 저장이 끝나면 getRoamingData 를 실행 하여 값을 초기화..
  // addRoaming -> getRoamingData -> provider -> notifyListeners()


  Future<void> removeAllData(String id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("roaming$id");
  }
}
