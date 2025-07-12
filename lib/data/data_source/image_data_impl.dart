
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/data_source/preference/image_preference.dart';
import 'package:ready_go_project/data/repositories/image_local_data_repo.dart';

class ImageDataImpl implements ImageLocalDataRepo {
  ImagePreference get pref => ImagePreference.singleton;
  final logger = Logger();

  @override
  Future<List<String>> getArrivalImgList(String id) async {
    try {
      List<String> list = await pref.getArrivalImgList(id);
      return list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<String>> getDepartureImgList(String id) async {
    try {
      final list = await pref.getDepartImgList(id);
      return list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> addArrivalImage(List<String> list, String id)async {
    try {
       await pref.setArrivalImage(list, id);
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> addDepartureImage(List<String> list, String id)async {
    try {
      await pref.setDepartureImage(list, id);
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeArrivalImage(List<String> list, String id) async {
    try {
      await pref.setArrivalImage(list, id);
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeDepartureImage(List<String> list, String id) async {
    try {
      await pref.setDepartureImage(list, id);
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeAllData(String id) async {
    await pref.removeAllData(id);
  }

  @override
  Future<String?> getPassportImg() async {
    String? pass = await pref.getPassImg();
    return pass;
  }

  @override
  Future<int> setPassportImg(String path) async{
    int result = await pref.setPassImg(path);
    return result;
  }
}
