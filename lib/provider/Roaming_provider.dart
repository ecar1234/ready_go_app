import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';
import 'package:ready_go_project/domain/use_cases/roaming_use_case.dart';

class RoamingProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;

  List<XFile>? _imageList = [];
  String? _dpAddress;
  String? _code;
  RoamingPeriodModel? _period;

  List<XFile> get imageList => _imageList!;

  String get dpAddress => _dpAddress!;

  String get code => _code!;

  RoamingPeriodModel get period => _period!;

  Future<void> getRoamingDate(int id) async {
    try {
      var data = await _getIt.get<RoamingUseCase>().getRoamingData(id);
      if (data.imgList!.isEmpty) {
        _imageList = [];
      } else {
        _imageList = data.imgList!.map((img) => XFile(img)).toList();
      }
      _dpAddress = data.dpAddress;
      _code = data.activeCode;
      _period = data.period;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addImage(XFile image, int id) async {
    var list = await _getIt.get<RoamingUseCase>().addImage(image, id);
    _imageList = list;
    notifyListeners();
  }

  Future<void> removeImage(XFile image, int id) async {
    var list = await _getIt.get<RoamingUseCase>().removeImage(image, id);
    _imageList = list;
    notifyListeners();
  }

  Future<void> enterAddress(String addr, int id) async {
    _dpAddress = addr;
    await _getIt.get<RoamingUseCase>().enterAddress(addr, id);

    notifyListeners();
  }

  Future<void> removeAddress(int id) async {
    _dpAddress = "";
    await _getIt.get<RoamingUseCase>().removeAddress(id);

    notifyListeners();
  }

  Future<void> enterCode(String code, int id) async {
    _code = code;
    await _getIt.get<RoamingUseCase>().enterCode(code, id);

    notifyListeners();
  }


  Future<void> removeCode(int id) async {
    _code = "";
    await _getIt.get<RoamingUseCase>().removeCode(id);

    notifyListeners();
  }

  Future<void> setPeriodDate(int day, int id) async {
    var periodData = await _getIt.get<RoamingUseCase>().setPeriodDate(day, id);
    _period = periodData;

    notifyListeners();
  }

  Future<void> startPeriod(int id) async {
    var periodData = await _getIt.get<RoamingUseCase>().startPeriod(id);
    _period = periodData;

    notifyListeners();
  }

  Future<void> resetPeriod(int id) async {
    var periodData = await _getIt.get<RoamingUseCase>().resetPeriod(id);
    _period = periodData;
    notifyListeners();
  }

  Future<void> removeAllData(int id)async{
    await _getIt.get<RoamingUseCase>().removeAllData(id);
    _imageList = null;
    _dpAddress =null;
    _code = null;
    _period = null;

    notifyListeners();
  }
}
