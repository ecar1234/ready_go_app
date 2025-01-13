import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/data_source/preference/image_preference.dart';
import 'package:ready_go_project/domain/repositories/image_local_data_repo.dart';

class ImageEntity implements ImageLocalDataRepo {
  ImagePreference get pref => ImagePreference.singleton;

  @override
  Future<List<XFile>> getArrivalImgList(int id) async {
    try {
      List<XFile> list = await pref.getArrivalImgList(id);
      return list;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> getDepartureImgList(int id) async {
    try {
      List<XFile> list = await pref.getDepartImgList(id);
      return list;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> addArrivalImage(XFile image, int id)async {
    try {
      var list = await pref.addArrivalImage(image, id);
      return list;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> addDepartureImage(XFile image, int id)async {
    try {
      var list = await pref.addDepartureImage(image, id);
      return list;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> removeArrivalImage(XFile image, int id) async {
    try {
      var list = await pref.removeArrivalImage(image, id);
      return list;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> removeDepartureImage(XFile image, int id) async {
    try {
      var list = await pref.removeDepartureImage(image, id);
      return list;
    } catch (ex) {
      log(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeAllData(int id) async {
    await pref.removeAllData(id);
  }

  @override
  Future<XFile?> getPassportImg() async {
    XFile? pass = await pref.getPassImg();
    return pass;
  }

  @override
  Future<int> setPassportImg(String path) async{
    int result = await pref.setPassImg(path);
    return result;
  }
}
