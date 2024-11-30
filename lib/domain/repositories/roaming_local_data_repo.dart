
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_model.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';

mixin RoamingLocalDataRepo {
  Future<RoamingModel> getRoamingData(int id);

  Future<List<XFile>> getRoamingImgList(int id);
  Future<String> getRoamingAddress(int id);
  Future<String> getRoamingCode(int id);
  Future<RoamingPeriodModel> getRoamingPeriod(int id);

  Future<void> updateRoamingPeriod(RoamingPeriodModel period, int id);
  Future<void> updateRoamingImgList(List<XFile> list, int id);
  Future<void> updateRoamingAddress(String addr, int id);
  Future<void> updateRoamingCode(String code, int id);
}