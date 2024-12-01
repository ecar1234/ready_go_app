


import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/domain/entities/supplies_entity.dart';

class SuppliesUseCase {
  final GetIt _getIt = GetIt.I;

  Future<List<SupplyModel>> getSuppliesList(int id) async {
    var list = await _getIt.get<SuppliesEntity>().getSuppliesList(id);
    return list;
  }


  Future<List<SupplyModel>> addSuppliesItem(SupplyModel item, int id) async {
    var list = await _getIt.get<SuppliesEntity>().getSuppliesList(id);
    list.add(item);
    await _getIt.get<SuppliesEntity>().addSuppliesItem(list, id);
    return list;

  }

  Future<List<SupplyModel>> editSuppliesItem(int idx, String item, int id) async {
    var list = await _getIt.get<SuppliesEntity>().getSuppliesList(id);
    list[idx].item = item;
    await _getIt.get<SuppliesEntity>().editSuppliesItem(list, id);

    return list;

  }

  Future<List<SupplyModel>> removeSuppliesItem(int idx, int id) async {
    var list = await _getIt.get<SuppliesEntity>().getSuppliesList(id);
    list.removeAt(idx);
    await _getIt.get<SuppliesEntity>().removeSuppliesItem(list, id);
    return list;
  }

  Future<List<SupplyModel>> updateSupplyState(int idx, int id) async {
    var list = await _getIt.get<SuppliesEntity>().getSuppliesList(id);
    list[idx].isCheck = !list[idx].isCheck!;
    await _getIt.get<SuppliesEntity>().updateSuppliesItem(list, id);

    return list;
  }

  Future<List<SupplyModel>> removeAllData(int id)async{
    await _getIt.get<SuppliesEntity>().removeAllData(id);
    return [];
  }


}