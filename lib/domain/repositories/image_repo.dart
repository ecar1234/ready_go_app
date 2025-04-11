import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

mixin ImageRepo{
  Future<List<List<File>>> getImageList(int id);
  Future<List<File>> addDepartureFile(List<PlatformFile> files, int id);
  Future<List<File>> addArrivalFile(List<PlatformFile> files, int id);
  Future<List<File>> addArrivalImg(XFile image, int id);
  Future<List<File>> addDepartureImg(XFile image, int id);
  Future<List<File>> removeArrivalImg(File image, int id);
  Future<List<File>> removeDepartureImg(File image, int id);
  Future<List<List<File>>> removeAllData(int id);
  Future<File?> setPassportImg(XFile img);
  Future<File?> getPassportImg();
}