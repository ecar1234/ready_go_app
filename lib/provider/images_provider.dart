import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/use_cases/image_use_case.dart';

class ImagesProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;
  late List<XFile> _departureImage;
  late List<XFile> _arrivalImage;

  List<XFile> get departureImg => _departureImage;

  List<XFile> get arrivalImg => _arrivalImage;

  Future<void> getImgList(int id) async {
    try {
      var imgList = await _getIt.get<ImageUseCase>().getImageList(id);
      _departureImage = imgList[0];
      _arrivalImage = imgList[1];
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addDepartureImage(XFile image, int id) async {
    try {
      List<XFile> list = await GetIt.I.get<ImageUseCase>().addDepartureImg(image, id);
      _departureImage = list;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> addArrivalImage(XFile image, int id) async {
    try {
      List<XFile> list = await GetIt.I.get<ImageUseCase>().addArrivalImg(image, id);
      _arrivalImage = list;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeDepartureImage(XFile image, int id) async {
    try {
      List<XFile> list = await GetIt.I.get<ImageUseCase>().removeDepartureImg(image, id);
      _departureImage = list;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeArrivalImage(XFile image, int id) async {
    try {
      List<XFile> list = await GetIt.I.get<ImageUseCase>().removeArrivalImg(image, id);
      _arrivalImage = list;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
    notifyListeners();
  }
}
