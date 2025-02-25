
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../repositories/image_repo.dart';

class ImagesProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();
  late List<XFile> _departureImage;
  late List<XFile> _arrivalImage;

  List<XFile> get departureImg => _departureImage;

  List<XFile> get arrivalImg => _arrivalImage;


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
      List<XFile> list = await GetIt.I.get<ImageRepo>().addDepartureImg(image, id);
      _departureImage = list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addArrivalImage(XFile image, int id) async {
    try {
      List<XFile> list = await GetIt.I.get<ImageRepo>().addArrivalImg(image, id);
      _arrivalImage = list;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeDepartureImage(XFile image, int id) async {
    try {
      List<XFile>? list = await GetIt.I.get<ImageRepo>().removeDepartureImg(image, id);
      if(list != null){
        _departureImage = list;
      }else {
        _departureImage = [];
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeArrivalImage(XFile image, int id) async {
    try {
      List<XFile>? list = await GetIt.I.get<ImageRepo>().removeArrivalImg(image, id);
      if(list != null){
        _arrivalImage = list;
      }else {
        _arrivalImage = [];
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeAllData(int id)async{
    await _getIt.get<ImageRepo>().removeAllData(id);
    _arrivalImage = [];
    _departureImage = [];

    notifyListeners();
  }
}
