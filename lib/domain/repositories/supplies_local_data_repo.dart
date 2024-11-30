
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';

mixin SuppliesLocalDataRepo {
  Future<List<SupplyModel>> getSuppliesList(int id);
  Future<void> addSuppliesItem(List<SupplyModel> list, int id);
  Future<void> removeSuppliesItem(List<SupplyModel> list, int id);
  Future<void> editSuppliesItem(List<SupplyModel> list, int id);
  Future<void> updateSuppliesItem(List<SupplyModel> list, int id);
}