
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';

mixin ExpectationRepo {

  Future<List<ExpectationModel>> getExpectationData(int id);

  Future<List<ExpectationModel>> addExpectationData(ExpectationModel item, int id);

  Future<List<ExpectationModel>> removeExpectationData(int index, int id);

  Future<List<ExpectationModel>> modifyExpectationData(ExpectationModel item, int idx, int id);

  Future<void> removeAllData(int id);
}