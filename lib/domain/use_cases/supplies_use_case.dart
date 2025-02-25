import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/repositories/supplies_repo.dart';

import '../../data/models/supply_model/supply_model.dart';
import '../../data/repositories/supplies_local_data_repo.dart';

class SuppliesUseCase with SuppliesRepo{
  final GetIt _getIt = GetIt.I;

  @override
  Future<List<SupplyModel>> getSuppliesList(int id) async {
    var list = await _getIt.get<SuppliesLocalDataRepo>().getSuppliesList(id);
    return list;
  }

  @override
  Future<List<SupplyModel>> addSuppliesItem(SupplyModel item, int id) async {
    var list = await _getIt.get<SuppliesLocalDataRepo>().getSuppliesList(id);
    list.add(item);
    await _getIt.get<SuppliesLocalDataRepo>().addSuppliesItem(list, id);
    return list;

  }

  @override
  Future<List<SupplyModel>> editSuppliesItem(int idx, String item, int id) async {
    var list = await _getIt.get<SuppliesLocalDataRepo>().getSuppliesList(id);
    list[idx].item = item;
    await _getIt.get<SuppliesLocalDataRepo>().editSuppliesItem(list, id);

    return list;

  }

  @override
  Future<List<SupplyModel>> removeSuppliesItem(int idx, int id) async {
    var list = await _getIt.get<SuppliesLocalDataRepo>().getSuppliesList(id);
    list.removeAt(idx);
    await _getIt.get<SuppliesLocalDataRepo>().removeSuppliesItem(list, id);
    return list;
  }

  @override
  Future<List<SupplyModel>> updateSupplyState(int idx, int id) async {
    var list = await _getIt.get<SuppliesLocalDataRepo>().getSuppliesList(id);
    list[idx].isCheck = !list[idx].isCheck!;
    await _getIt.get<SuppliesLocalDataRepo>().updateSuppliesItem(list, id);

    return list;
  }

  @override
  Future<List<SupplyModel>> removeAllData(int id)async{
    await _getIt.get<SuppliesLocalDataRepo>().removeAllData(id);
    return [];
  }


}