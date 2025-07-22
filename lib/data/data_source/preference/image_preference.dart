import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImagePreference {
  ImagePreference._internal();

  static final ImagePreference _singleton = ImagePreference._internal();

  static ImagePreference get singleton => _singleton;

  final logger = Logger();

  // Images provider
  Future<List<String>> getDepartImgList(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? json = pref.getString("departureImg$id");
      if (json != null) {
        List<String> pathList = List<String>.from(jsonDecode(json));
        return pathList;
      } else {
        return [];
      }
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  Future<List<String>> getArrivalImgList(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      String? json = pref.getString("arrivalImg$id");
      if (json != null) {
        List<String> pathList = List<String>.from(jsonDecode(json));
        return pathList;
      } else {
        return [];
      }
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  Future<void> setDepartureImage(List<String> list, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? jsonList = jsonEncode(list);
      pref.setString("departureImg$id", jsonList);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> setArrivalImage(List<String> list, String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? jsonList = jsonEncode(list);
      pref.setString("arrivalImg$id", jsonList);
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<void> removeAllData(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("arrivalImg$id");
    pref.remove("departureImg$id");
  }

  Future<String?> getPassImg() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      String? path = pref.getString("passportImg");
      if (path != null) {
        return path;
      } else {
        logger.w("passport img is null");
        return null;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<int> setPassImg(String path) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try {
      pref.setString("passportImg", path);

      return 200;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
