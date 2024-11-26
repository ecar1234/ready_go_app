import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/domain/use_cases/accommodation_data_use_case.dart';

class AccommodationProvider with ChangeNotifier {
  List<AccommodationModel>? _accommodation;

  List<AccommodationModel>? get accommodation => _accommodation;

  Future<void> getAccommodationList(int id) async {
    try {
      List<AccommodationModel> list = await GetIt.I.get<AccommodationDataUseCase>().getAccommodationList(id);
      _accommodation = list;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addAccommodation(AccommodationModel info, int id) async {
    try {
      if (_accommodation != null) {
        _accommodation!.add(info);
      } else {
        _accommodation = [];
        _accommodation!.add(info);
      }
      await _updateAccommodationList(_accommodation!, id);
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeAccommodation(AccommodationModel info, int id) async {
    try{
      _accommodation!.removeWhere((item) => item == info);
      await _updateAccommodationList(_accommodation!, id);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> _updateAccommodationList(List<AccommodationModel> list, int id) async {
    try{
      await GetIt.I.get<AccommodationDataUseCase>().updateAccommodationList(list, id);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }
}
