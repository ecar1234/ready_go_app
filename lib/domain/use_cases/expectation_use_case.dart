import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';

import '../../data/repositories/expectation_local_data_repo.dart';
import '../repositories/expectation_repo.dart';

class ExpectationUseCase with ExpectationRepo{

  @override
  Future<List<ExpectationModel>> getExpectationData(String id) async {
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    if(list.any((item) => item.unit == null)){
      final planList = await GetIt.I.get<PlanLocalDataRepo>().getLocalList();
      final plan = planList.firstWhere((item) => item.id == id);
      for(var item in list){
        item.unit ??= plan.unit;
      }
      await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    }
    return list;
  }

  @override
  Future<List<ExpectationModel>> addExpectationData(ExpectationModel item, String id) async {
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    list.add(item);
    await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    return list;
  }

  @override
  Future<List<ExpectationModel>> modifyExpectationData(ExpectationModel item, int idx, String id) async{
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    list[idx] = item;
    await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    return list;
  }

  @override
  Future<List<ExpectationModel>> removeExpectationData(int index, String id) async {
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    list.removeAt(index);
    await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    return list;
  }

  @override
  Future<void> removeAllData(String id)async {
    await GetIt.I.get<ExpectationLocalDataRepo>().removeAllData(id);
  }



}