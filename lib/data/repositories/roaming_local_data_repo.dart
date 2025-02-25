
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_model.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';

mixin RoamingLocalDataRepo {
  Future<RoamingModel> getRoamingData(int id);
  Future<void> setRoamingImgList(List<String> image, int id);
  Future<void> setRoamingAddress(RoamingModel newData, int id);
  Future<void> setRoamingCode(RoamingModel newData, int id);
  Future<void> setRoamingPeriod(RoamingModel newData, int id);
  // Future<void> addRoamingImg(XFile image, int id);
  // Future<void> removeRoamingImg(XFile image, int id);
  Future<void> removeAllData(int id);
}