
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';

mixin ExpectationRepo {

  Future<List<ExpectationModel>> getExpectationData(String id);

  Future<List<ExpectationModel>> addExpectationData(ExpectationModel item, String id);

  Future<List<ExpectationModel>> removeExpectationData(int index, String id);

  Future<List<ExpectationModel>> modifyExpectationData(ExpectationModel item, int idx, String id);

  Future<void> removeAllData(String id);
}