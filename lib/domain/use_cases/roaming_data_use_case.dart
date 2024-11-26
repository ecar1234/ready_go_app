
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/data_source/preference/preference_provider.dart';
import 'package:ready_go_project/domain/repositories/roaming_local_data_repo.dart';

class RoamingDataUseCase implements RoamingLocalDataRepo {
  PreferenceProvider get pref => PreferenceProvider.singleton;

  @override
  Future<List<XFile>> getRoamingImgList(int id)async {
    List<XFile> list = await pref.getRoamingImageList(id);
    return list;
  }
  @override
  Future<Map<String, bool>> getRoamingAddress(int id)async {
    Map<String, bool> address = await pref.getRoamingAddress(id);
    return address;
  }
  @override
  Future<Map<String, bool>> getRoamingCode(int id)async {
    Map<String, bool> code = await pref.getRoamingCode(id);
    return code;
  }

  @override
  Future<void> updateRoamingAddress(Map<String, bool> addr, int id) async{
    await pref.updateRoamingAddress(addr, id);
  }

  @override
  Future<void> updateRoamingCode(Map<String, bool> code, int id) async{
    await pref.updateRoamingCode(code, id);
  }

  @override
  Future<void> updateRoamingImgList(List<XFile> list, int id) async{
    await pref.updateRoamingImgList(list, id);
  }

  @override
  Future<Map<String, dynamic>> getRoamingPeriod(int id) async{
   Map<String, dynamic> period =  await pref.getRoamingPeriod(id);
   return period;
  }

  @override
  Future<void> updateRoamingPeriod(Map<String, dynamic> period, int id)async {
    await pref.updateRoamingPeriod(period, id);
  }

}