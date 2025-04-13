
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';
import 'package:ready_go_project/domain/repositories/expectation_repo.dart';

final _getIt = GetIt.I.get<ExpectationRepo>();
class ExpectationProvider with ChangeNotifier {

  List<ExpectationModel>? _expectationList;

  List<ExpectationModel>? get expectationList => _expectationList;

  Future<void> getExpectationData(int id)async{
    final list = await _getIt.getExpectationData(id);
    _expectationList = list;
    notifyListeners();
  }

  Future<void> addExpectationData(ExpectationModel item, int id)async{
    final list = await _getIt.addExpectationData(item, id);
    _expectationList = list;
    notifyListeners();
  }
  Future<void> modifyExpectationData(ExpectationModel item, int idx, int id)async{
    final list = await _getIt.modifyExpectationData(item, idx, id);
    _expectationList = list;
    notifyListeners();
  }

  Future<void> removeExpectationData(int index, int id)async{
    final list = await _getIt.removeExpectationData(index, id);
    _expectationList = list;
    notifyListeners();
  }
  Future<void> removeAllData(int id)async{
    await _getIt.removeAllData(id);
    _expectationList = [];
    notifyListeners();
  }
}