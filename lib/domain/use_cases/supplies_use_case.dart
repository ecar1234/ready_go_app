import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/repositories/supplies_repo.dart';

import '../../data/models/supply_model/supply_model.dart';
import '../../data/repositories/supplies_local_data_repo.dart';

  final _getIt = GetIt.I.get<SuppliesLocalDataRepo>();
class SuppliesUseCase with SuppliesRepo{

  @override
  Future<List<SupplyModel>> getSuppliesList(String id) async {
    var list = await _getIt.getSuppliesList(id);
    return list;
  }

  @override
  Future<List<SupplyModel>> addSuppliesItem(SupplyModel item, String id) async {
    var list = await _getIt.getSuppliesList(id);
    list.add(item);
    await _getIt.addSuppliesItem(list, id);
    return list;

  }

  @override
  Future<List<SupplyModel>> editSuppliesItem(int idx, String item, String id) async {
    var list = await _getIt.getSuppliesList(id);
    list[idx].item = item;
    await _getIt.editSuppliesItem(list, id);

    return list;

  }

  @override
  Future<List<SupplyModel>> removeSuppliesItem(int idx, String id) async {
    var list = await _getIt.getSuppliesList(id);
    list.removeAt(idx);
    await _getIt.removeSuppliesItem(list, id);
    return list;
  }

  @override
  Future<List<SupplyModel>> updateSupplyState(int idx, String id) async {
    var list = await _getIt.getSuppliesList(id);
    list[idx].isCheck = !list[idx].isCheck!;
    await _getIt.updateSuppliesItem(list, id);

    return list;
  }

  @override
  Future<List<SupplyModel>> removeAllData(String id)async{
    await _getIt.removeAllData(id);
    return [];
  }

  @override
  Future<void> addTemplateList(List<SupplyModel> list, String id) async{
    await _getIt.updateSuppliesItem(list, id);
  }


}