
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/domain/use_cases/supplies_data_use_case.dart';

class SuppliesProvider with ChangeNotifier{
  late List<Map<String, bool>> _suppliesList;

  List<Map<String, bool>> get suppliesList => _suppliesList;

  Future<void> getList(int id)async{
    if(id != -1){
      _suppliesList = await GetIt.I.get<SuppliesDataUseCase>().getSuppliesList(id);
      notifyListeners();
    }else{
      print("plan id is -1, check the plan id");
    }
  }

  Future<void> addItem(Map<String, bool> item, int id)async{
    _suppliesList.add(item);
    await GetIt.I.get<SuppliesDataUseCase>().addSuppliesItem(_suppliesList, id);
    notifyListeners();
  }

  Future<void> removeItem(Map<String, bool> item, int id)async{
    _suppliesList.removeWhere((e) => e.keys.first == item.keys.first);
    await GetIt.I.get<SuppliesDataUseCase>().removeSuppliesItem(_suppliesList, id);
    notifyListeners();
  }
  Future<void> updateItemState(Map<String, bool> item, int id)async{
    for(var e in _suppliesList){
      if(e.containsKey(item.keys.first)){
        e[item.keys.first] = !e.values.first;
        break;
      }
    }
    await GetIt.I.get<SuppliesDataUseCase>().updateSuppliesItem(_suppliesList, id);
    notifyListeners();
  }
  Future<void> editItem(int idx, Map<String, bool> item, int id)async{
    _suppliesList.removeAt(idx);
    _suppliesList.insert(idx, item);
    await GetIt.I.get<SuppliesDataUseCase>().updateSuppliesItem(_suppliesList, id);

    notifyListeners();
  }

}