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
  Future<RoamingModel> getRoamingData(String id) async {
    final data = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

    Directory dir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> imgFileList = Directory(dir.path).listSync();
    List<String> roamingImgList = imgFileList.where((file) => file is File && file.path.contains("roamingImages$id")).map((file) => file.path).toList();

    if(data.imgList!.isNotEmpty){
      final setDeparturePath = data.imgList!.toSet();
      final roamingFilePathSet = roamingImgList.map((path) => path).toSet();
      bool isAllSame =
          setDeparturePath.length == roamingFilePathSet.length && setDeparturePath.difference(roamingFilePathSet).isEmpty;
      if (!isAllSame) {
        data.imgList = roamingImgList;
        await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(roamingImgList, id);
      }
      return data;
    }
    data.imgList = roamingImgList;
    return data;
  }

  @override
  Future<RoamingModel> addRoamingImage(XFile image, String id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

    Directory dir = await getApplicationDocumentsDirectory();
    String imgPath = "${dir.path}/roamingImages$id${image.name}";
    if(await File(image.path).exists()){
      await File(image.path).copy(imgPath);
      if(await File(imgPath).exists()){
        res.imgList!.add(imgPath);
        await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(res.imgList!, id);
        res.imgList!.map((path) => File(path)).toList();
        return res;
      }else{
        logger.e("roaming image copy failed");
        throw Exception("");
      }
    }else {
      logger.e("the pick up roaming image path is no exists.");
      throw Exception("");
    }
  }

  @override
  Future<RoamingModel> removeRoamingImage(File image, String id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    String? targetPath = res.imgList!.firstWhere((path) => path.contains(image.path.split("/").last), orElse: () => "");

    if(await File(targetPath).exists()){
      await File(targetPath).delete();
      res.imgList!.removeWhere((path) => path == targetPath);
      await _getIt.get<RoamingLocalDataRepo>().setRoamingImgList(res.imgList!, id);
      res.imgList!.map((path) => File(path)).toList();
      return res;
    }else {
      logger.e("The file requested for deletion does not exist.");
      throw Exception("");
    }
  }

  // @override
  // Future<void> enterAddress(String addr, int id) async {
  //   RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
  //   res.dpAddress = addr;
  //   await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  // }

  @override
  Future<void> removeAddress(String id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    res.dpAddress = "";
    await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  }

  @override
  Future<void> enterCode(String address, String code, String id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    res.activeCode = code;
    res.dpAddress = address;
    await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  }

  @override
  Future<void> removeCode(String id) async {
    RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
    res.activeCode = "";
    await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
  }

  @override
  Future<RoamingModel> setPeriodDate(int day, String id) async {
    try {
      RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);
      final period = RoamingPeriodModel()
        ..period = day
        ..isActive = false;
      res.period = period;
      await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
      return res;

    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<RoamingModel> startPeriod(String id) async {
    try {
      RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

      res.period!
        ..isActive = true
        ..startDate = DateTime.now()
        ..endDate = DateTime.now().add(Duration(days: res.period!.period!));

      await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
      return res;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<RoamingModel> resetPeriod(String id) async {
    try {
      RoamingModel? res = await _getIt.get<RoamingLocalDataRepo>().getRoamingData(id);

      final period = RoamingPeriodModel()
        ..period = 0
        ..isActive = false
        ..startDate = null
        ..endDate = null;
      res.period = period;
      await _getIt.get<RoamingLocalDataRepo>().setRoamingData(res, id);
      return res;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<RoamingModel> removeAllData(String id) async {
    await _getIt.get<RoamingLocalDataRepo>().removeAllData(id);
    return RoamingModel();
  }
}
