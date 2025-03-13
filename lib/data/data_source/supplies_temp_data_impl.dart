import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/data_source/preference/supplies_temp_preference.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:ready_go_project/data/repositories/supplies_temp_local_repo.dart';

class SuppliesTempDataImpl with SuppliesTempLocalRepo{
  SuppliesTempPreference get  pref => SuppliesTempPreference.singleton;

  @override
  Future<List<TemplateModel>> getTemplateList() async{
    final list = await pref.getTempList();
    return list;
  }

  @override
  Future<void> setTemplateList(List<TemplateModel> list) async{
    await pref.setTempList(list);
  }
}