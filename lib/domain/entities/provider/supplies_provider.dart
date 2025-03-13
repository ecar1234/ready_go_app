import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';

import '../../repositories/supplies_repo.dart';

  final _getIt = GetIt.I.get<SuppliesRepo>();
class SuppliesProvider with ChangeNotifier {

  late List<SupplyModel> _suppliesList;

  List<SupplyModel> get suppliesList => _suppliesList;

  Future<void> getList(int id) async {
    var list = await _getIt.getSuppliesList(id);
    _suppliesList = list;

    notifyListeners();
  }

  Future<void> addItem(SupplyModel item, int id) async {
    var list = await _getIt.addSuppliesItem(item, id);
    _suppliesList = list;
    notifyListeners();
  }

  Future<void> removeItem(int idx, int id) async {
    var list = await _getIt.removeSuppliesItem(idx, id);
    _suppliesList = list;
    notifyListeners();
  }

  Future<void> editItem(int idx, String item, int id) async {
    var list = await _getIt.editSuppliesItem(idx, item, id);
    _suppliesList = list;
    notifyListeners();
  }

  Future<void> updateItemState(int idx, int id) async {
    var list = await _getIt.updateSupplyState(idx, id);
    _suppliesList = list;

    notifyListeners();
  }
  Future<void> addTemplateList(List<SupplyModel> list, int id)async{
    _suppliesList.addAll(list);
    await _getIt.addTemplateList(_suppliesList, id);
    notifyListeners();
  }

  Future<void> removeAllData(int id)async{
    await _getIt.removeAllData(id);
    _suppliesList = [];

    notifyListeners();
  }
}
