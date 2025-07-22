
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';

mixin SuppliesLocalDataRepo {
  Future<List<SupplyModel>> getSuppliesList(String id);
  Future<void> addSuppliesItem(List<SupplyModel> list, String id);
  Future<void> removeSuppliesItem(List<SupplyModel> list, String id);
  Future<void> editSuppliesItem(List<SupplyModel> list, String id);
  Future<void> updateSuppliesItem(List<SupplyModel> list, String id);
  Future<void> removeAllData(String id);
}