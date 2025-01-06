import 'dart:convert';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePreference {
  ImagePreference._internal();

  static final ImagePreference _singleton = ImagePreference._internal();

  static ImagePreference get singleton => _singleton;

  // Images provider
  Future<List<XFile>> getDepartImgList(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? json = pref.getString("departureImg$id");
      if (json != null) {
        List<String> pathList = List<String>.from(jsonDecode(json));
        return pathList.map((path) => XFile(path)).toList();
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  Future<List<XFile>> getArrivalImgList(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? json = pref.getString("arrivalImg$id");
      if (json != null) {
        List<String> pathList = List<String>.from(jsonDecode(json));
        return pathList.map((path) => XFile(path)).toList();
      } else {
        return [];
      }
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }
  Future<List<XFile>> addDepartureImage(XFile image, int id)async{
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String? json =  pref.getString("departureImg$id");
      if(json != null){
        List<String> pathList = List<String>.from(jsonDecode(json));
        pathList.add(image.path);
        String? jsonList = jsonEncode(pathList);
        pref.setString("departureImg$id", jsonList);
        List<XFile> list = pathList.map((path) => XFile(path)).toList();
        return list;
      }else{
        List<String> list = [];
        list.add(image.path);
        String? jsonList = jsonEncode(list);
        pref.setString("departureImg$id", jsonList);
        return [image];
      }
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<XFile>> addArrivalImage(XFile image, int id)async{
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String? json =  pref.getString("arrivalImg$id");
      if(json != null){
        List<String> pathList = List<String>.from(jsonDecode(json));
        pathList.add(image.path);
        String? jsonList = jsonEncode(pathList);
        pref.setString("arrivalImg$id", jsonList);
        List<XFile> list = pathList.map((path) => XFile(path)).toList();
        return list;
      }else{
        List<String> list = [];
        list.add(image.path);
        String? jsonList = jsonEncode(list);
        pref.setString("arrivalImg$id", jsonList);
        return [image];
      }
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<XFile>> removeDepartureImage(XFile image, int id)async{
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? json =  pref.getString("departureImg$id");
      if(json != null){
        List<String> pathList = List<String>.from(jsonDecode(json));
        pathList.removeWhere((path) => path == image.path);
        String? jsonList = jsonEncode(pathList);
        pref.setString("departureImg$id", jsonList);
        List<XFile> list = pathList.map((path) => XFile(path)).toList();
        return list;
      }else{
        return [];
      }
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  Future<List<XFile>> removeArrivalImage(XFile image, int id)async{
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();

      String? json =  pref.getString("arrivalImg$id");
      if(json != null){
        List<String> pathList = List<String>.from(jsonDecode(json));
        pathList.removeWhere((path) => path == image.path);
        String? jsonList = jsonEncode(pathList);
        pref.setString("arrivalImg$id", jsonList);
        List<XFile> list = pathList.map((path) => XFile(path)).toList();
        return list;
      }else{
        return [];
      }
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> removeAllData(int id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("arrivalImg$id");
    pref.remove("departureImg$id");
  }
}
