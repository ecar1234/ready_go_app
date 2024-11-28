import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/use_cases/roaming_data_use_case.dart';

class RoamingProvider with ChangeNotifier {
  List<XFile> _imageList = [];
  Map<String, bool> _dpAddress = {};
  Map<String, bool> _code ={};
  Map<String, dynamic> _period ={
    "period" :0,
    "isActive": false,
    "startDate": DateTime.now(),
    "endDate": DateTime.now()
  };
  bool isLoading = false;

  List<XFile> get imageList => _imageList;

  Map<String, bool> get dpAddress => _dpAddress;

  Map<String, bool> get code => _code;

  Map<String, dynamic> get period => _period;

  Future<void> getRoamingDate(int id) async {
    isLoading = true;
    List<XFile> list = await GetIt.I.get<RoamingDataUseCase>().getRoamingImgList(id);
    Map<String, bool> dpAddress = await GetIt.I.get<RoamingDataUseCase>().getRoamingAddress(id);
    Map<String, bool> code = await GetIt.I.get<RoamingDataUseCase>().getRoamingCode(id);
    Map<String, dynamic> period = await GetIt.I.get<RoamingDataUseCase>().getRoamingPeriod(id);

    _imageList = list;
    _dpAddress = dpAddress;
    _code = code;
    _period = period;

    isLoading = false;
    notifyListeners();
  }

  Future<void> addImage(XFile image, int id) async {
    _imageList.add(image);
    await updateImage(_imageList, id);
    notifyListeners();
  }

  Future<void> removeImage(XFile image, int id) async {
    _imageList.removeWhere((e) => e.path == image.path);
    await updateImage(_imageList, id);
    notifyListeners();
  }

  Future<void> enterAddress(Map<String, bool> addr, int id) async {
    _dpAddress = addr;
    await updateAddress(_dpAddress, id);
    notifyListeners();
  }

  Future<void> editAddress(Map<String, bool> addr, int id) async {
    _dpAddress = addr;
    await updateAddress(_dpAddress, id);
    notifyListeners();
  }

  Future<void> removeAddress(int id) async {
    _dpAddress = {};
    await updateAddress(_dpAddress, id);
    notifyListeners();
  }

  Future<void> enterCode(Map<String, bool> code, int id) async {
    _code = code;
    await updateCode(_code, id);
    notifyListeners();
  }

  Future<void> editCode(Map<String, bool> code, int id) async {
    _code = code;
    await updateCode(_code, id);
    notifyListeners();
  }

  Future<void> removeCode(int id) async {
    _code = {};
    await updateCode(_code, id);
    notifyListeners();
  }

  Future<void> setPeriodDate(int day, int id)async{
    _period["period"] = day;

    _period["startDate"] = DateTime.now();
    DateTime endDate = _period["startDate"] as DateTime;
    int period = _period["period"] as int;
    _period["endDate"] = endDate.add(Duration(days: period));

    await updatePeriod(_period, id);
    notifyListeners();
  }
  Future<void> startPeriod(int id)async{
    _period["isActive"] = true;
    await updatePeriod(_period, id);
    notifyListeners();
  }
  Future<void> resetPeriod(int id)async{
    _period = {
      "period" :0,
      "isActive": false,
      "startDate": DateTime.now(),
      "endDate": DateTime.now()
    };
    await updatePeriod(_period, id);
    notifyListeners();
  }

  Future<void> updateImage(List<XFile> image, int id) async {
    await GetIt.I.get<RoamingDataUseCase>().updateRoamingImgList(image, id);
  }

  Future<void> updateAddress(Map<String, bool> addr, int id) async {
    await GetIt.I.get<RoamingDataUseCase>().updateRoamingAddress(addr, id);
  }

  Future<void> updateCode(Map<String, bool> newCode, int id) async {
    await GetIt.I.get<RoamingDataUseCase>().updateRoamingCode(newCode, id);
  }
  Future<void> updatePeriod(Map<String, dynamic> period, int id)async{
    await GetIt.I.get<RoamingDataUseCase>().updateRoamingPeriod(period, id);
  }

}