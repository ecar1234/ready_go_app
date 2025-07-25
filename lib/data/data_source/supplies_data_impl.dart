import 'package:ready_go_project/data/data_source/preference/supplies_preference.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';

import '../repositories/supplies_local_data_repo.dart';


class SuppliesDataImpl implements SuppliesLocalDataRepo {
  SuppliesPreference get pref => SuppliesPreference.singleton;

  @override
  Future<List<SupplyModel>> getSuppliesList(String id) async {
    var list = await pref.getSuppliesList(id);
    return list;
  }

  @override
  Future<void> addSuppliesItem(List<SupplyModel> list, String id) async {
    await pref.updateSupplyList(list, id);
  }

  @override
  Future<void> removeSuppliesItem(List<SupplyModel> list, String id) async {
    await pref.updateSupplyList(list, id);
  }

  @override
  Future<void> updateSuppliesItem(List<SupplyModel> list, String id) async {
    await pref.updateSupplyList(list, id);
  }

  @override
  Future<void> editSuppliesItem(List<SupplyModel> list, String id) async {
    await pref.updateSupplyList(list, id);
  }

  @override
  Future<void> removeAllData(String id) async {
    await pref.removeAllData(id);
  }
}
