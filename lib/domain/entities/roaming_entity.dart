import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/data_source/preference/roaming_preference.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_model.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';
import 'package:ready_go_project/domain/repositories/roaming_local_data_repo.dart';

class RoamingEntity implements RoamingLocalDataRepo {
  RoamingPreference get pref => RoamingPreference.singleton;

  @override
  Future<RoamingModel> getRoamingData(int id) async {
    var data = await pref.getRoamingData(id);
    return data;
  }

  @override
  Future<String> getRoamingAddress(int id) async {
    var addr = await pref.getRoamingAddress(id);
    return addr;
  }

  @override
  Future<String> getRoamingCode(int id) async {
    var code = await pref.getRoamingCode(id);
    return code;
  }

  @override
  Future<List<XFile>> getRoamingImgList(int id) async {
    var list = await pref.getRoamingImageList(id);
    return list;
  }

  @override
  Future<RoamingPeriodModel> getRoamingPeriod(int id) async {
    var period = await pref.getRoamingPeriod(id);
    return period;
  }

  @override
  Future<void> updateRoamingAddress(String addr, int id) async {
    var data = await pref.getRoamingData(id);
    data.dpAddress = addr;
    await pref.updateRoamingData(data, id);
  }

  @override
  Future<void> updateRoamingCode(String code, int id) async {
    var data = await pref.getRoamingData(id);
    data.activeCode = code;
    await pref.updateRoamingData(data, id);
  }

  @override
  Future<void> updateRoamingImgList(List<XFile> list, int id) async {
    List<String> newList = [];

    var data = await pref.getRoamingData(id);
    newList = list.map((img) => img.path).toList();
    data.imgList = newList;
    await pref.updateRoamingData(data, id);
  }

  @override
  Future<void> updateRoamingPeriod(RoamingPeriodModel period, int id) async {
    var data = await pref.getRoamingData(id);
    data.period = period;
    await pref.updateRoamingData(data, id);
  }
}
