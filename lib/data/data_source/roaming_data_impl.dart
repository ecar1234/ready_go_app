import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/data_source/preference/roaming_preference.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_model.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';

import '../repositories/roaming_local_data_repo.dart';

class RoamingDataImpl implements RoamingLocalDataRepo {
  RoamingPreference get pref => RoamingPreference.singleton;
  final logger = Logger();
  @override
  Future<RoamingModel> getRoamingData(String id) async {
    try {
      var data = await pref.getRoamingData(id);
      if(data == null){
        return RoamingModel()
        ..activeCode = ""
        ..dpAddress = ""
        ..imgList = []
        ..period = RoamingPeriodModel(
          isActive: false,
          period: 0
        );
      }
      return data;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setRoamingData(RoamingModel newData, String id) async {
    await pref.setRoamingData(newData, id);
  }



  @override
  Future<void> setRoamingImgList(List<String> paths, String id) async {
    var res = await pref.getRoamingData(id);
    if (res != null) {
      res.imgList = paths;
      await pref.setRoamingData(res, id);
    } else {
      RoamingModel data = RoamingModel()..imgList = paths;
      await pref.setRoamingData(data, id);
    }
  }



  @override
  Future<void> removeAllData(String id) async {
    await pref.removeAllData(id);
  }
}
