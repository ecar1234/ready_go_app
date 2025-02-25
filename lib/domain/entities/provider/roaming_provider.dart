import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';
import 'package:ready_go_project/domain/repositories/roaming_repo.dart';
import 'package:ready_go_project/domain/use_cases/roaming_use_case.dart';

class RoamingProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;
  final logger = Logger();

  List<XFile>? _imageList = [];
  String? _dpAddress;
  String? _code;
  RoamingPeriodModel? _period;

  List<XFile>? get imageList => _imageList;

  String? get dpAddress => _dpAddress;

  String? get code => _code;

  RoamingPeriodModel? get period => _period;

  Future<void> getRoamingDate(int id) async {
    try {
      var data = await _getIt.get<RoamingRepo>().getRoamingData(id);
      if(data.imgList != null && data.imgList!.isNotEmpty){
        _imageList = data.imgList!.map((path) => XFile(path)).toList();
      }else{
        _imageList = [];
      }
      _dpAddress = data.dpAddress;
      _code = data.activeCode;
      _period = data.period;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addImage(XFile image, int id) async {
    var list = await _getIt.get<RoamingRepo>().addRoamingImage(image, id);
    _imageList = list;
    notifyListeners();
  }

  Future<void> removeImage(XFile image, int id) async {
    var list = await _getIt.get<RoamingRepo>().removeRoamingImage(image, id);
    _imageList = list;
    notifyListeners();
  }

  Future<void> enterAddress(String addr, int id) async {
    _dpAddress = addr;
    await _getIt.get<RoamingRepo>().enterAddress(addr, id);

    notifyListeners();
  }

  Future<void> removeAddress(int id) async {
    _dpAddress = "";
    await _getIt.get<RoamingRepo>().removeAddress(id);

    notifyListeners();
  }

  Future<void> enterCode(String code, int id) async {
    _code = code;
    await _getIt.get<RoamingRepo>().enterCode(code, id);

    notifyListeners();
  }

  Future<void> removeCode(int id) async {
    _code = "";
    await _getIt.get<RoamingRepo>().removeCode(id);

    notifyListeners();
  }

  Future<void> setPeriodDate(int day, int id) async {
    final periodData = await _getIt.get<RoamingRepo>().setPeriodDate(day, id);
    if (periodData != null) {
      _period = periodData;
      notifyListeners();
    } else {
      logger.e("set period return is null");
    }
  }

  Future<void> startPeriod(int id) async {
    var periodData = await _getIt.get<RoamingRepo>().startPeriod(id);
    _period = periodData;

    notifyListeners();
  }

  Future<void> resetPeriod(int id) async {
    var periodData = await _getIt.get<RoamingRepo>().resetPeriod(id);
    _period = periodData;
    notifyListeners();
  }

  Future<void> removeAllData(int id) async {
    await _getIt.get<RoamingRepo>().removeAllData(id);
    _imageList = null;
    _dpAddress = null;
    _code = null;
    _period = null;

    notifyListeners();
  }
}
