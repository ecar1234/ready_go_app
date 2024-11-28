import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/data_source/preference/preference_provider.dart';
import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';
import 'package:ready_go_project/domain/repositories/accommodation_local_data_repo.dart';

class AccommodationDataUseCase implements AccommodationLocalDateRepo {
  PreferenceProvider get pref => PreferenceProvider.singleton;

  @override
  Future<List<AccommodationModel>> getAccommodationList(int id) async{
    var list = await pref.getAccommodationList(id);
    return list;
  }

  @override
  Future<void> updateAccommodationList(List<AccommodationModel> list, int id)async {
    await pref.updateAccommodationList(list, id);
  }
}
