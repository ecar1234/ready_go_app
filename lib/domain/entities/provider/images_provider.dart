import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../repositories/image_repo.dart';

class ImagesProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();
  late List<File> _departureImage;
  late List<File> _arrivalImage;

  List<File> get departureImg => _departureImage;

  List<File> get arrivalImg => _arrivalImage;

  Future<void> getImgList(int id) async {
    try {
      var imgList = await _getIt.get<ImageRepo>().getImageList(id);
      _departureImage = imgList[0];
      _arrivalImage = imgList[1];
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addDepartureImage(XFile image, int id) async {
    try {
      final list = await GetIt.I.get<ImageRepo>().addDepartureImg(image, id);
      _departureImage = list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addArrivalImage(XFile image, int id) async {
    try {
      final list = await GetIt.I.get<ImageRepo>().addArrivalImg(image, id);
      _arrivalImage = list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeDepartureImage(File image, int id) async {
    try {
      final list = await GetIt.I.get<ImageRepo>().removeDepartureImg(image, id);
      _departureImage = list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeArrivalImage(File image, int id) async {
    try {
      final list = await GetIt.I.get<ImageRepo>().removeArrivalImg(image, id);

      _arrivalImage = list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeAllData(int id) async {
    await _getIt.get<ImageRepo>().removeAllData(id);
    _arrivalImage = [];
    _departureImage = [];

    notifyListeners();
  }
}
