
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_model.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';

mixin RoamingLocalDataRepo {
  Future<RoamingModel> getRoamingData(String id);
  Future<void> setRoamingData(RoamingModel newData, String id);
  Future<void> setRoamingImgList(List<String> image, String id);
  // Future<void> setRoamingCode(RoamingModel newData, int id);
  // Future<void> setRoamingPeriod(RoamingModel newData, int id);
  // Future<void> addRoamingImg(XFile image, int id);
  // Future<void> removeRoamingImg(XFile image, int id);
  Future<void> removeAllData(String id);
}