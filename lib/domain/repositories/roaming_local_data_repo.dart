
import 'package:image_picker/image_picker.dart';

mixin RoamingLocalDataRepo {
  Future<List<XFile>> getRoamingImgList(int id);
  Future<Map<String, bool>> getRoamingAddress(int id);
  Future<Map<String, bool>> getRoamingCode(int id);
  Future<Map<String, dynamic>> getRoamingPeriod(int id);
  Future<void> updateRoamingPeriod(Map<String, dynamic> period, int id);
  Future<void> updateRoamingImgList(List<XFile> list, int id);
  Future<void> updateRoamingAddress(Map<String, bool> addr, int id);
  Future<void> updateRoamingCode(Map<String, bool> code, int id);
}