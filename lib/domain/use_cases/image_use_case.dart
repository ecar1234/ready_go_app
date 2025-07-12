import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ready_go_project/domain/repositories/image_repo.dart';

import '../../data/repositories/image_local_data_repo.dart';

class ImageUseCase with ImageRepo {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();

  @override
  Future<List<File>> addArrivalFile(List<PlatformFile> files, String id) async {
    try {
      List<String> arrivalPathList = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);
      Directory dir = await getApplicationDocumentsDirectory();

      for(var file in files){
        String newFilePath = "${dir.path}/arrivalImg$id${file.name}";

        if (file.path != null && await File(file.path!).exists()) {
          await File(file.path!).copy(newFilePath);
          if (await File(newFilePath).exists()) {
            arrivalPathList.add(newFilePath);
          } else {
            throw Exception("image save failed!");
          }
        } else {
          logger.e("image XFile path is not exists");
        }
      }
      await _getIt.get<ImageLocalDataRepo>().addArrivalImage(arrivalPathList, id);
      return arrivalPathList.map((path) => File(path)).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<File>> addDepartureFile(List<PlatformFile> files, String id) async {
    try {
      List<String> departurePathList = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
      Directory dir = await getApplicationDocumentsDirectory();

      for(var file in files){
        String newFilePath = "${dir.path}/departureImg$id${file.name}";

        if (file.path != null && await File(file.path!).exists()) {
          await File(file.path!).copy(newFilePath);
          if (await File(newFilePath).exists()) {
            departurePathList.add(newFilePath);
            // await _getIt.get<ImageLocalDataRepo>().addDepartureImage(departurePathList, id);
            // return departurePathList.map((path) => File(path)).toList();
          } else {
            throw Exception("image save failed!");
          }
        } else {
          logger.e("image XFile path is not exists");
        }
      }
      await _getIt.get<ImageLocalDataRepo>().addDepartureImage(departurePathList, id);
      return departurePathList.map((path) => File(path)).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<List<File>>> getImageList(String id) async {
    try {
      final departurePathList = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
      final arrivalPathList = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);

      Directory dir = await getApplicationDocumentsDirectory();
      List<FileSystemEntity> imgFileList = Directory(dir.path).listSync();

      try {
        List<File>? departureImages =
            imgFileList.where((file) => file is File && file.path.contains("departureImg$id")).map((file) => File(file.path)).toList();
        List<File>? arrivalImages =
            imgFileList.where((file) => file is File && file.path.contains("arrivalImg$id")).map((file) => File(file.path)).toList();

        if (departurePathList.isNotEmpty) {
          final setDeparturePath = departurePathList.toSet();
          final departureFilePathSet = departureImages.map((file) => file.path).toSet();
          bool isDepartureAllSame =
              setDeparturePath.length == departureFilePathSet.length && setDeparturePath.difference(departureFilePathSet).isEmpty;
          if (!isDepartureAllSame) {
            await _getIt.get<ImageLocalDataRepo>().addDepartureImage(departureFilePathSet.toList(), id);
          }
        }
        if (arrivalPathList.isNotEmpty) {
          final setArrivalPath = arrivalPathList.toSet();
          final arrivalFilePathSet = arrivalImages.map((file) => file.path).toSet();
          bool isArrivalAllSame = setArrivalPath.length == arrivalFilePathSet.length && setArrivalPath.difference(arrivalFilePathSet).isEmpty;
          if (!isArrivalAllSame) {
            await _getIt.get<ImageLocalDataRepo>().addArrivalImage(arrivalFilePathSet.toList(), id);
          }
        }
        return [departureImages, arrivalImages];
      } on Exception catch (e) {
        logger.e(e.toString());
      }
      return [[], []];
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<File>> addArrivalImg(XFile image, String id) async {
    try {
      List<String> arrivalPathList = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);
      Directory dir = await getApplicationDocumentsDirectory();
      String imgPath = "${dir.path}/arrivalImg$id${image.name}";

      if (await File(image.path).exists()) {
        await File(image.path).copy(imgPath);
        if (await File(imgPath).exists()) {
          arrivalPathList.add(imgPath);
          await _getIt.get<ImageLocalDataRepo>().addArrivalImage(arrivalPathList, id);
          return arrivalPathList.map((path) => File(path)).toList();
        } else {
          throw Exception("image save failed!");
        }
      } else {
        logger.e("image XFile path is not exists");
      }

      return arrivalPathList.map((path) => File(path)).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<File>> addDepartureImg(XFile image, String id) async {
    try {
      List<String> departurePathList = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
      Directory dir = await getApplicationDocumentsDirectory();
      String imgPath = "${dir.path}/departureImg$id${image.name}";

      if (await File(image.path).exists()) {
        await File(image.path).copy(imgPath);
        if (await File(imgPath).exists()) {
          departurePathList.add(imgPath);
          await _getIt.get<ImageLocalDataRepo>().addDepartureImage(departurePathList, id);
          return departurePathList.map((path) => File(path)).toList();
        } else {
          throw Exception("image save failed!");
        }
      } else {
        logger.e("image XFile path is not exists");
      }

      return departurePathList.map((path) => File(path)).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<File>> removeArrivalImg(File image, String id) async {
    try {
      List<String> arrivalPathList = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);
      String? targetPath = arrivalPathList.firstWhere((path) => path.contains(image.path.split("/").last), orElse: () => "");
      if (await File(targetPath).exists()) {
        await File(targetPath).delete();
        arrivalPathList.removeWhere((path) => path == targetPath);
        await _getIt.get<ImageLocalDataRepo>().removeArrivalImage(arrivalPathList, id);
        return arrivalPathList.map((path) => File(path)).toList();
      } else {
        logger.e("The file requested for deletion does not exist.");
        throw Exception("");
      }
      // return arrivalPathList.map((path) => File(path)).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<File>> removeDepartureImg(File image, String id) async {
    try {
      List<String> departurePathList = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
      String? targetPath = departurePathList.firstWhere((path) => path.contains(image.path.split("/").last), orElse: () => "");

      if (await File(targetPath).exists()) {
        await File(targetPath).delete();
        departurePathList.removeWhere((path) => path == targetPath);
        await _getIt.get<ImageLocalDataRepo>().removeDepartureImage(departurePathList, id);
        return departurePathList.map((path) => File(path)).toList();
      } else {
        logger.e("The file requested for deletion does not exist.");
        throw Exception("");
      }
      // return departurePathList.map((path) => File(path)).toList();
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<List<File>>> removeAllData(String id) async {
    await _getIt.get<ImageLocalDataRepo>().removeAllData(id);
    return [[], []];
  }

  @override
  Future<File?> getPassportImg() async {
    final res = await _getIt.get<ImageLocalDataRepo>().getPassportImg();

    if (res != null && res.isNotEmpty) {
      if (await File(res).exists()) {
        return File(res);
      } else {
        Directory dir = await getApplicationDocumentsDirectory();
        List<FileSystemEntity> imgFileList = Directory(dir.path).listSync();
        bool isExists = imgFileList.any((file) => file.path.contains("passportImg"));
        if (isExists) {
          File passImg = File(imgFileList.firstWhere((file) => file is File && file.path.contains("passportImg")).path);
          await _getIt.get<ImageLocalDataRepo>().setPassportImg(passImg.path);
          return passImg;
        }
      }
    }
    return null;
  }

  @override
  Future<File?> setPassportImg(XFile img) async {
    final res = await _getIt.get<ImageLocalDataRepo>().getPassportImg();
    Directory dir = await getApplicationDocumentsDirectory();
    String imgPath = "${dir.path}/passportImg.jpg";

    if (res != null) {
      if (await File(res).exists()) {
        await File(res).delete();
      }
    }

    if (await File(img.path).exists()) {
      await File(img.path).copy(imgPath);
      if (await File(imgPath).exists()) {
        await _getIt.get<ImageLocalDataRepo>().setPassportImg(imgPath);
        return File(imgPath);
      } else {
        logger.e("image file copy failed.");
        throw Exception("");
      }
    } else {
      logger.e("The file requested for save does not exist.");
      throw Exception("");
    }
  }
}
