
import 'package:image_picker/image_picker.dart';

mixin ImageLocalDataRepo {
  Future<List<String>> getDepartureImgList(String id);
  Future<List<String>> getArrivalImgList(String id);
  Future<void> addDepartureImage(List<String> list, String id);
  Future<void> addArrivalImage(List<String> list, String id);
  Future<void> removeDepartureImage(List<String> list, String id);
  Future<void> removeArrivalImage(List<String> list, String id);
  Future<String?> getPassportImg();
  Future<int> setPassportImg(String path);
  Future<void> removeAllData(String id);
}