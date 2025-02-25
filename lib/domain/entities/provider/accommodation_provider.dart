
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/domain/repositories/accommodation_repo.dart';

class AccommodationProvider with ChangeNotifier {
  List<AccommodationModel>? _accommodation;

  List<AccommodationModel>? get accommodation => _accommodation;
  final logger = Logger();

  Future<void> getAccommodationList(int id) async {
    try {
      List<AccommodationModel> list = await GetIt.I.get<AccommodationRepo>().getAccommodationList(id);
      _accommodation = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> addAccommodation(AccommodationModel info, int id) async {
    try {
      var list = await GetIt.I.get<AccommodationRepo>().addAccommodation(info, id);
      _accommodation = list;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeAccommodation(int idx, int id) async {
    try{
      var list = await GetIt.I.get<AccommodationRepo>().removeAccommodation(idx, id);
      _accommodation = list;
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }

    notifyListeners();
  }

  Future<void> removeAllData(int id)async{
    await GetIt.I.get<AccommodationRepo>().removeAllData(id);
  }
}
