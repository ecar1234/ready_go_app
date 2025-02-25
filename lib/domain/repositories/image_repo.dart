import 'package:image_picker/image_picker.dart';

mixin ImageRepo{
  Future<List<List<XFile>>> getImageList(int id);
  Future<List<XFile>> addArrivalImg(XFile image, int id);
  Future<List<XFile>> addDepartureImg(XFile image, int id);
  Future<List<XFile>?> removeArrivalImg(XFile image, int id);
  Future<List<XFile>?> removeDepartureImg(XFile image, int id);
  Future<List<List<XFile>>> removeAllData(int id);
  Future<int> setPassportImg(XFile img);
  Future<XFile?> getPassportImg();
}