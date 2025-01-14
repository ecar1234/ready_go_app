import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
        Directory dir = await getApplicationDocumentsDirectory();
        String path = "${dir.path}/${image.name}";
        pathList.add(image.path);
        String? jsonList = jsonEncode(path);
        pref.setString("departureImg$id", jsonList);
        List<XFile> list = pathList.map((path) => XFile(path)).toList();
        return list;
      }else{
        List<String> list = [];
        Directory dir = await getApplicationDocumentsDirectory();
        String path = "${dir.path}/${image.name}";
        list.add(path);
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
        Directory dir = await getApplicationDocumentsDirectory();
        String path = "${dir.path}/${image.name}";
        pathList.add(path);
        String? jsonList = jsonEncode(pathList);
        pref.setString("arrivalImg$id", jsonList);
        List<XFile> list = pathList.map((path) => XFile(path)).toList();
        return list;
      }else{
        List<String> list = [];
        Directory dir = await getApplicationDocumentsDirectory();
        String path = "${dir.path}/${image.name}";
        list.add(path);
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
        Directory dir = await getApplicationDocumentsDirectory();
        String imgPath = "${dir.path}/${image.name}";
        pathList.removeWhere((path) => path == imgPath);
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
        Directory dir = await getApplicationDocumentsDirectory();
        String imgPath = "${dir.path}/${image.name}";
        pathList.removeWhere((path) => path == imgPath);
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

  Future<XFile?> getPassImg()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? path = pref.getString("passportImg");
      if(path != null){
        XFile? img = XFile(path);
        return img;
      }else {
        return null;
      }
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  Future<int> setPassImg(String path)async{
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      pref.setString("passportImg", path);
      return 200;
    } on Exception catch (e) {
      log(e.toString());
      rethrow;
    }

  }
}
