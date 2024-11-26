
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/repositories/image_local_data_repo.dart';

import '../../data/data_source/preference/preference_provider.dart';

class ImageDataUseCase implements ImageLocalDataRepo {
  PreferenceProvider get pref => PreferenceProvider.singleton;


  @override
  Future<List<XFile>> getArrivalImgList(int id) async {
    List<XFile> imgList = await pref.getArrivalImgList(id);
    return imgList;
  }

  @override
  Future<List<XFile>> getDepartureImgList(int id) async {
    List<XFile> imgList = await pref.getDepartImgList(id);
    return imgList;
  }

  @override
  Future<void> addArrivalImg(XFile image, int id) async {
    pref.addArrivalImg(image, id);
  }

  @override
  Future<void> addDepartureImg(XFile image, int id) async {
    pref.addDepartureImg(image, id);
  }

  @override
  Future<void> removeArrivalImg(XFile image, int id) async {
    pref.removeArrivalImg(image, id);
  }

  @override
  Future<void> removeDepartImg(XFile image, int id) async {
    pref.removeDepartureImg(image, id);
  }

}