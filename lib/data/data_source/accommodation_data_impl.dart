
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/data_source/preference/accommodation_preference.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/data/repositories/accommodation_local_data_repo.dart';

class AccommodationDataImpl implements AccommodationLocalDateRepo{
  AccommodationPreference get pref => AccommodationPreference.singleton;
  final logger = Logger();

  @override
  Future<List<AccommodationModel>> getAccommodationList(String id)async {
    try{
      var list = await pref.getAccommodationList(id);
      return list;
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateAccommodationList(List<AccommodationModel> list, String id)async {
    try{
      await pref.updateAccommodationList(list, id);
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> removeAllData(String id)async {
    await pref.removeAllData(id);
  }


}