import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/domain/use_cases/supplies_use_case.dart';

class SuppliesProvider with ChangeNotifier {
  final GetIt _getIt = GetIt.I;

  late List<SupplyModel> _suppliesList;

  List<SupplyModel> get suppliesList => _suppliesList;

  Future<void> getList(int id) async {
    var list = await _getIt.get<SuppliesUseCase>().getSuppliesList(id);
    _suppliesList = list;

    notifyListeners();
  }

  Future<void> addItem(SupplyModel item, int id) async {
    var list = await _getIt.get<SuppliesUseCase>().addSuppliesItem(item, id);
    _suppliesList = list;
    notifyListeners();
  }

  Future<void> removeItem(int idx, int id) async {
    var list = await _getIt.get<SuppliesUseCase>().removeSuppliesItem(idx, id);
    _suppliesList = list;
    notifyListeners();
  }

  Future<void> editItem(int idx, String item, int id) async {
    var list = await _getIt.get<SuppliesUseCase>().editSuppliesItem(idx, item, id);
    _suppliesList = list;
    notifyListeners();
  }

  Future<void> updateItemState(int idx, int id) async {
    var list = await _getIt.get<SuppliesUseCase>().updateSupplyState(idx, id);
    _suppliesList = list;

    notifyListeners();
  }
}
