import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

mixin ImageRepo{
  Future<List<List<File>>> getImageList(String id);
  Future<List<File>> addDepartureFile(List<PlatformFile> files, String id);
  Future<List<File>> addArrivalFile(List<PlatformFile> files, String id);
  Future<List<File>> addArrivalImg(XFile image, String id);
  Future<List<File>> addDepartureImg(XFile image, String id);
  Future<List<File>> removeArrivalImg(File image, String id);
  Future<List<File>> removeDepartureImg(File image, String id);
  Future<List<List<File>>> removeAllData(String id);
  Future<File?> setPassportImg(XFile img);
  Future<File?> getPassportImg();
}