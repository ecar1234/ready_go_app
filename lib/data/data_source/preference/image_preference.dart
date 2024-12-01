import 'dart:convert';

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
      print(ex.toString());
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
      print(ex.toString());
      rethrow;
    }
  }

  Future<void> updateDepartureImgList(List<XFile> list, int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      List<String> stringJson = list.map((img) => img.path).toList();
      String? json = jsonEncode(stringJson);
      pref.setString("departureImg$id", json);
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
  }

  Future<void> updateArrivalImgList(List<XFile> list, int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      List<String> stringJson = list.map((img) => img.path).toList();
      String? json = jsonEncode(stringJson);
      pref.setString("arrivalImg$id", json);
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
  }
}
