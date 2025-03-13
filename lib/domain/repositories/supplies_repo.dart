import '../../data/models/supply_model/supply_model.dart';

mixin SuppliesRepo {
  Future<List<SupplyModel>> getSuppliesList(int id);
  Future<List<SupplyModel>> addSuppliesItem(SupplyModel item, int id);
  Future<List<SupplyModel>> editSuppliesItem(int idx, String item, int id);
  Future<List<SupplyModel>> removeSuppliesItem(int idx, int id);
  Future<List<SupplyModel>> updateSupplyState(int idx, int id);
  Future<List<SupplyModel>> removeAllData(int id);
  Future<void> addTemplateList(List<SupplyModel> list, int id);
}