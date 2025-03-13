
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';

mixin SuppliesTempRepo {
  Future<List<TemplateModel>> getTempList();
  Future<List<TemplateModel>> addTempList(TemplateModel temp);
  Future<List<TemplateModel>> changeTempList(List<String> temp, int idx);
  Future<List<TemplateModel>> removeTempList(int tempIdx);
}