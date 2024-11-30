
import 'package:ready_go_project/data/data_source/preference/accommodation_preference.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/domain/repositories/accommodation_local_data_repo.dart';

class AccommodationEntity implements AccommodationLocalDateRepo{
  AccommodationPreference get pref => AccommodationPreference.singleton;

  @override
  Future<List<AccommodationModel>> getAccommodationList(int id)async {
    try{
      var list = await pref.getAccommodationList(id);
      return list;
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateAccommodationList(List<AccommodationModel> list, int id)async {
    try{
      await pref.updateAccommodationList(list, id);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }

}