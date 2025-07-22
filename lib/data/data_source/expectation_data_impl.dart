
import 'package:ready_go_project/data/data_source/preference/expectation_preference.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';
import 'package:ready_go_project/data/repositories/expectation_local_data_repo.dart';

class ExpectationDataImpl with ExpectationLocalDataRepo {
  ExpectationPreference get pref => ExpectationPreference.singleton;

  @override
  Future<List<ExpectationModel>> getExpectationData(String id)async {
    final list = await pref.getExpectationData(id);
    return list;

  }

  @override
  Future<void> updateExpectationData(List<ExpectationModel> list, String id) async{
    await pref.updateExpectationDate(list, id);
  }

  @override
  Future<void> removeAllData(String id)async {
    await pref.removeAllData(id);
  }

}