
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/entities/accommodation_entity.dart';

import '../../data/models/accommodation_model/accommodation_model.dart';

GetIt _getIt = GetIt.I;
class AccommodationUseCase {
  Future<List<AccommodationModel>> getAccommodationList(int id)async{
    try{
      var list = _getIt.get<AccommodationEntity>().getAccommodationList(id);
      return list;
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }

  Future<List<AccommodationModel>> addAccommodation(AccommodationModel info, int id) async {
    List<AccommodationModel> list = [];

    try{
      list = await _getIt.get<AccommodationEntity>().getAccommodationList(id);
      list.add(info);

      await _getIt.get<AccommodationEntity>().updateAccommodationList(list, id);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
    return list;
  }

  Future<List<AccommodationModel>> removeAccommodation(int idx, int id) async {
    List<AccommodationModel> list = [];
    try{
      list = await _getIt<AccommodationEntity>().getAccommodationList(id);
      list.removeAt(idx);

      await _getIt.get<AccommodationEntity>().updateAccommodationList(list, id);

    }catch(ex){
      print(ex.toString());
      rethrow;
    }
      return list;
  }
}
