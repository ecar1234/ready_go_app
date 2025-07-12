import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';
import 'package:ready_go_project/domain/repositories/roaming_repo.dart';
import 'package:ready_go_project/domain/use_cases/roaming_use_case.dart';

import '../../../data/models/roaming_model/roaming_model.dart';

class RoamingProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();
  RoamingModel? _roamingData;

  String _tempCode = "";
  String _tempAddress = "";

  String get tempCode => _tempCode;
  String get tempAddress => _tempAddress;
  RoamingModel? get roamingData => _roamingData;

  Future<void> getRoamingDate(String id) async {
    try {
      var data = await _getIt.get<RoamingRepo>().getRoamingData(id);
     _roamingData = data;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addImage(XFile image, String id) async {
    final data = await _getIt.get<RoamingRepo>().addRoamingImage(image, id);
    _roamingData = data;
    notifyListeners();
  }

  Future<void> removeImage(File image, String id) async {
    final data = await _getIt.get<RoamingRepo>().removeRoamingImage(image, id);
    _roamingData = data;
    notifyListeners();
  }

  // Future<void> enterAddress(String addr, int id) async {
  //   await _getIt.get<RoamingRepo>().enterAddress(addr, id);
  //   _dpAddress = addr;
  //
  //   notifyListeners();
  // }

  Future<void> removeAddress(String id) async {
    await _getIt.get<RoamingRepo>().removeAddress(id);
    _roamingData!.dpAddress = "";

    notifyListeners();
  }

  Future<void> enterCode(String address, String code, String id) async {
    await _getIt.get<RoamingRepo>().enterCode(address, code, id);
    _roamingData!.activeCode = code;
    _roamingData!.dpAddress = address;
    notifyListeners();
  }

  Future<void> removeCode(String id) async {
    await _getIt.get<RoamingRepo>().removeCode(id);
    _roamingData!.activeCode = "";

    notifyListeners();
  }

  Future<void> setPeriodDate(int day, String id) async {
    final data = await _getIt.get<RoamingRepo>().setPeriodDate(day, id);
    _roamingData = data;
    notifyListeners();
  }

  Future<void> startPeriod(String id) async {
    var data = await _getIt.get<RoamingRepo>().startPeriod(id);
    _roamingData = data;
    notifyListeners();
  }

  Future<void> resetPeriod(String id) async {
    var data = await _getIt.get<RoamingRepo>().resetPeriod(id);
    _roamingData = data;
    notifyListeners();
  }

  Future<void> removeAllData(String id) async {
    await _getIt.get<RoamingRepo>().removeAllData(id);
    _roamingData!
    ..period = null
    ..imgList =[]
    ..dpAddress = ""
    ..activeCode = "";

    notifyListeners();
  }

  void updateTempCode(String code){
    _tempCode = code;
    notifyListeners();
  }
  void updateTempAddress(String address){
    _tempAddress = address;
    notifyListeners();
  }
}
