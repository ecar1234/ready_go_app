

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:ready_go_project/domain/repositories/supplies_temp_repo.dart';

final _getIt = GetIt.I.get<SuppliesTempRepo>();
class SuppliesTemplateProvider with ChangeNotifier {
  List<TemplateModel>? _tempList;
  List<SupplyModel> _selectedList = [];
  List<TemplateModel>? get tempList => _tempList;
  List<SupplyModel> get selectedList => _selectedList;

  Future<void> getTempList()async{
    final list = await _getIt.getTempList();
    _tempList = list;
    notifyListeners();
  }
  Future<void> addTemplate(TemplateModel temp)async {
    final list = await _getIt.addTempList(temp);
    _tempList = list;
    notifyListeners();
  }
  Future<void> changeTemplate(List<String> temp, idx)async {
    final list = await _getIt.changeTempList(temp, idx);
    _tempList = list;
    notifyListeners();
  }
  Future<void> removeTemplate(int tempIdx)async{
    final list = await _getIt.removeTempList(tempIdx);
    _tempList = list;
    notifyListeners();
  }

  void selectTempList(List<SupplyModel>? list){
    if(list == null){
      _selectedList = [];
    }else {
      _selectedList = list!;
    }
    notifyListeners();
  }
}