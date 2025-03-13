
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';
import 'package:ready_go_project/data/models/supply_model/template_model.dart';
import 'package:ready_go_project/data/repositories/supplies_temp_local_repo.dart';
import 'package:ready_go_project/domain/repositories/supplies_temp_repo.dart';

final _getIt = GetIt.I.get<SuppliesTempLocalRepo>();
class SuppliesTempUseCase with SuppliesTempRepo {
  @override
  Future<List<TemplateModel>> addTempList(TemplateModel temp) async{
    var list = await _getIt.getTemplateList();
    list.add(temp);
    await _getIt.setTemplateList(list);
    return list;
  }

  @override
  Future<List<TemplateModel>> getTempList() async{
    final list = await _getIt.getTemplateList();
    return list;
  }

  @override
  Future<List<TemplateModel>> removeTempList(int tempIdx) async{
    final list = await _getIt.getTemplateList();
    list.removeAt(tempIdx);
    await _getIt.setTemplateList(list);
    return list;
  }

  @override
  Future<List<TemplateModel>> changeTempList(List<String> temp, int idx) async{
    final list = await _getIt.getTemplateList();
    final newTemp = temp.map((item) => SupplyModel(item: item, isCheck: false)).toList();
    list[idx].temp = newTemp;
    await _getIt.setTemplateList(list);
    return list;
  }
}