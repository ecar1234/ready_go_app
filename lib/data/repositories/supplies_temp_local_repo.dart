
import 'package:ready_go_project/data/models/supply_model/template_model.dart';

mixin SuppliesTempLocalRepo {
  Future<List<TemplateModel>> getTemplateList();
  Future<void> setTemplateList(List<TemplateModel> list);
}