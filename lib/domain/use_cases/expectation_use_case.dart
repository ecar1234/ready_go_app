import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';

import '../../data/repositories/expectation_local_data_repo.dart';
import '../repositories/expectation_repo.dart';

class ExpectationUseCase with ExpectationRepo{

  @override
  Future<List<ExpectationModel>> getExpectationData(int id) async {
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    return list;
  }

  @override
  Future<List<ExpectationModel>> addExpectationData(ExpectationModel item, int id) async {
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    list.add(item);
    await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    return list;
  }

  @override
  Future<List<ExpectationModel>> modifyExpectationData(ExpectationModel item, int idx, int id) async{
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    list[idx] = item;
    await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    return list;
  }

  @override
  Future<List<ExpectationModel>> removeExpectationData(int index, int id) async {
    final list = await GetIt.I.get<ExpectationLocalDataRepo>().getExpectationData(id);
    list.removeAt(index);
    await GetIt.I.get<ExpectationLocalDataRepo>().updateExpectationData(list, id);
    return list;
  }

  @override
  Future<void> removeAllData(int id)async {
    await GetIt.I.get<ExpectationLocalDataRepo>().removeAllData(id);
  }



}