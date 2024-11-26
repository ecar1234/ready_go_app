
import '../../data/data_source/preference/preference_provider.dart';
import '../repositories/supplies_local_data_repo.dart';

class SuppliesDataUseCase implements SuppliesLocalDataRepo {
  PreferenceProvider get pref => PreferenceProvider.singleton;

  @override
  Future<List<Map<String, bool>>> getSuppliesList(int id) async {
    return await pref.getSuppliesList(id);
  }

  @override
  Future<void> addSuppliesItem(List<Map<String, bool>> item, int id) async {
    await pref.addSuppliesItem(item, id);
  }

  @override
  Future<void> removeSuppliesItem(List<Map<String, bool>> item, int id) async {
    await pref.removeSuppliesItem(item, id);
  }

  @override
  Future<void> updateSuppliesItem(List<Map<String, bool>> item, int id) async{
   await pref.updateSuppliesItem(item, id);
  }

}