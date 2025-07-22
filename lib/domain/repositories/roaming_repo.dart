
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../data/models/roaming_model/roaming_model.dart';
import '../../data/models/roaming_model/roaming_period_model.dart';

mixin RoamingRepo {
  Future<RoamingModel> getRoamingData(String id);
  Future<RoamingModel> addRoamingImage(XFile image, String id);
  Future<RoamingModel> removeRoamingImage(File image, String id);
  // Future<void> enterAddress(String addr, int id);
  Future<void> removeAddress(String id);
  Future<void> enterCode(String address, String code, String id);
  Future<void> removeCode(String id);
  Future<RoamingModel> setPeriodDate(int day, String id);
  Future<RoamingModel> startPeriod(String id);
  Future<RoamingModel> resetPeriod(String id);
  Future<RoamingModel> removeAllData(String id);
}