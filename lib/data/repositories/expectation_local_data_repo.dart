import '../models/expectation_model/expectation_model.dart';

mixin ExpectationLocalDataRepo {

  Future<List<ExpectationModel>> getExpectationData(int id);

  Future<void> updateExpectationData(List<ExpectationModel> list, int id);

  Future<void> removeAllData(int id);
}