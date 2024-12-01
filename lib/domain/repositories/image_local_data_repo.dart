
import 'package:image_picker/image_picker.dart';

mixin ImageLocalDataRepo {
  Future<List<XFile>> getDepartureImgList(int id);
  Future<List<XFile>> getArrivalImgList(int id);
  Future<void> updateDepartureImgList(List<XFile> list, int id);
  Future<void> updateArrivalImgList(List<XFile> list, int id);
  Future<void> removeAllData(int id);
}