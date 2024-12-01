import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/domain/use_cases/accommodation_use_case.dart';

class AccommodationProvider with ChangeNotifier {
  List<AccommodationModel>? _accommodation;

  List<AccommodationModel>? get accommodation => _accommodation;

  Future<void> getAccommodationList(int id) async {
    try {
      List<AccommodationModel> list = await GetIt.I.get<AccommodationUseCase>().getAccommodationList(id);
      _accommodation = list;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addAccommodation(AccommodationModel info, int id) async {
    try {
      var list = await GetIt.I.get<AccommodationUseCase>().addAccommodation(info, id);
      _accommodation = list;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeAccommodation(int idx, int id) async {
    try{
      var list = await GetIt.I.get<AccommodationUseCase>().removeAccommodation(idx, id);
      _accommodation = list;
    }catch(ex){
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeAllData(int id)async{
    await GetIt.I.get<AccommodationUseCase>().removeAllData(id);
  }
}
