
import 'package:image_picker/image_picker.dart';

mixin ImageLocalDataRepo {
  Future<List<String>> getDepartureImgList(int id);
  Future<List<String>> getArrivalImgList(int id);
  Future<void> addDepartureImage(List<String> list, int id);
  Future<void> addArrivalImage(List<String> list, int id);
  Future<void> removeDepartureImage(List<String> list, int id);
  Future<void> removeArrivalImage(List<String> list, int id);
  Future<String?> getPassportImg();
  Future<int> setPassportImg(String path);
  Future<void> removeAllData(int id);
}