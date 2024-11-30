import 'package:ready_go_project/data/data_source/preference/supplies_preference.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/domain/repositories/supplies_local_data_repo.dart';

class SuppliesEntity implements SuppliesLocalDataRepo{
  SuppliesPreference get pref => SuppliesPreference.singleton;

  @override
  Future<List<SupplyModel>> getSuppliesList(int id)async {
    var list = await pref.getSuppliesList(id);
    return list;
  }

  @override
  Future<void> addSuppliesItem(List<SupplyModel> list, int id)async {
    await pref.updateSupplyList(list, id);
  }


  @override
  Future<void> removeSuppliesItem(List<SupplyModel> list, int id)async {
    await pref.updateSupplyList(list, id);
  }

  @override
  Future<void> updateSuppliesItem(List<SupplyModel> list, int id)async {
    await pref.updateSupplyList(list, id);
  }

  @override
  Future<void> editSuppliesItem(List<SupplyModel> list, int id) async {
    await pref.updateSupplyList(list, id);
  }
}