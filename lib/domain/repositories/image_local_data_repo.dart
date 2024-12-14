
import 'package:image_picker/image_picker.dart';

mixin ImageLocalDataRepo {
  Future<List<XFile>> getDepartureImgList(int id);
  Future<List<XFile>> getArrivalImgList(int id);
  Future<List<XFile>> addDepartureImage(XFile image, int id);
  Future<List<XFile>> addArrivalImage(XFile image, int id);
  Future<List<XFile>> removeDepartureImage(XFile image, int id);
  Future<List<XFile>> removeArrivalImage(XFile image, int id);
  Future<void> removeAllData(int id);
}