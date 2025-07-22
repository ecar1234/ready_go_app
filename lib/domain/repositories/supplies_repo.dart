import '../../data/models/supply_model/supply_model.dart';

mixin SuppliesRepo {
  Future<List<SupplyModel>> getSuppliesList(String id);
  Future<List<SupplyModel>> addSuppliesItem(SupplyModel item, String id);
  Future<List<SupplyModel>> editSuppliesItem(int idx, String item, String id);
  Future<List<SupplyModel>> removeSuppliesItem(int idx, String id);
  Future<List<SupplyModel>> updateSupplyState(int idx, String id);
  Future<List<SupplyModel>> removeAllData(String id);
  Future<void> addTemplateList(List<SupplyModel> list, String id);
}