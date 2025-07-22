import '../models/expectation_model/expectation_model.dart';

mixin ExpectationLocalDataRepo {

  Future<List<ExpectationModel>> getExpectationData(String id);

  Future<void> updateExpectationData(List<ExpectationModel> list, String id);

  Future<void> removeAllData(String id);
}