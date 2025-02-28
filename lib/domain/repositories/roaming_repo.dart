
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../data/models/roaming_model/roaming_model.dart';
import '../../data/models/roaming_model/roaming_period_model.dart';

mixin RoamingRepo {
  Future<RoamingModel> getRoamingData(int id);
  Future<List<File>> addRoamingImage(XFile image, int id);
  Future<List<File>> removeRoamingImage(File image, int id);
  // Future<void> enterAddress(String addr, int id);
  Future<void> removeAddress(int id);
  Future<void> enterCode(String address, String code, int id);
  Future<void> removeCode(int id);
  Future<RoamingPeriodModel?> setPeriodDate(int day, int id);
  Future<RoamingPeriodModel?> startPeriod(int id);
  Future<RoamingPeriodModel?> resetPeriod(int id);
  Future<RoamingModel> removeAllData(int id);
}