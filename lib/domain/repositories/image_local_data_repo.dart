
import 'package:image_picker/image_picker.dart';

mixin ImageLocalDataRepo {
  Future<List<XFile>> getDepartureImgList(int id);
  Future<List<XFile>> getArrivalImgList(int id);
  Future<void> addDepartureImg(XFile image, int id);
  Future<void> addArrivalImg(XFile image, int id);
  Future<void> removeDepartImg(XFile image, int id);
  Future<void> removeArrivalImg(XFile image, int id);
}