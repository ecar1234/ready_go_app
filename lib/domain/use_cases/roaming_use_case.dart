import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ready_go_project/domain/repositories/roaming_repo.dart';

import '../../data/models/roaming_model/roaming_model.dart';
import '../../data/models/roaming_model/roaming_period_model.dart';
import '../../data/repositories/roaming_local_data_repo.dart';

class RoamingUseCase with RoamingRepo {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();

  @override
  Future<RoamingModel> getRoamingData(int id) async {
    final data = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    return data;
  }

  @override
  Future<List<XFile>> addRoamingImage(XFile image, int id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

    Directory dir = await getApplicationDocumentsDirectory();
    String imgPath = "${dir.path}/roamingImages$id${image.name}";
    await File(image.path).copy(imgPath);

    // if (await file.exists()) {
    //   logger.w("roaming Image file already exists.");
    // } else {
    //   await file.writeAsBytes(await image.readAsBytes());
    // }

    if (res.imgList != null) {
      if (!res.imgList!.any((name) => name == image.name)) {
        res.imgList!.add(imgPath);
        await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(res.imgList!, id);
        return res.imgList!.map((path) => XFile(path)).toList();
      } else {
        logger.w("roaming Image path already exists.");
        return res.imgList!.map((path) => XFile(path)).toList();
      }
    } else {
      List<String> list = [];
      list.add(imgPath);
      await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(list, id);
      return [XFile(imgPath)];
    }
  }

  @override
  Future<List<XFile>> removeRoamingImage(XFile image, int id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

    String imgPath = image.path;
    File file = File(imgPath);

    if (await file.exists()) {
      await file.delete();
    } else {
      logger.w("roaming Image file not found.");
    }

    if (res.imgList != null) {
      if (res.imgList!.any((name) => name == imgPath)) {
        res.imgList!.remove(imgPath);
        await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(res.imgList!, id);
        return res.imgList!.map((path) => XFile(path)).toList();
      } else {
        logger.w("roaming Image path already exists.");
        return res.imgList!.map((path) => XFile(path)).toList();
      }
    } else {
      List<String> list = [];
      list.add(imgPath);
      await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(list, id);
      return [XFile(imgPath)];
    }
  }

  // @override
  // Future<void> enterAddress(String addr, int id) async {
  //   RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
  //   res.dpAddress = addr;
  //   await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  // }

  @override
  Future<void> removeAddress(int id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    res.dpAddress = "";
    await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  }

  @override
  Future<void> enterCode(String address, String code, int id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    res.activeCode = code;
    res.dpAddress = address;
    await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  }

  @override
  Future<void> removeCode(int id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    res.activeCode = "";
    await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  }

  @override
  Future<RoamingPeriodModel?> setPeriodDate(int day, int id) async {
    try {
      RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
      final period = RoamingPeriodModel()
        ..period = day
        ..isActive = false;
      res.period = period;
      await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
      return period;

    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<RoamingPeriodModel?> startPeriod(int id) async {
    try {
      RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

      final period = RoamingPeriodModel()
        ..isActive = true
        ..startDate = DateTime.now()
        ..endDate = DateTime.now().add(Duration(days: res.period!.period!));
      res.period = period;
      await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
      return period;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<RoamingPeriodModel?> resetPeriod(int id) async {
    try {
      RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

      final period = RoamingPeriodModel()
        ..period = 0
        ..isActive = false
        ..startDate = null
        ..endDate = null;
      res.period = period;
      await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
      return period;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<RoamingModel> removeAllData(int id) async {
    await _getIt.get<RoamingLocalDataRepo>().removeAllData(id);
    return RoamingModel();
  }
}
