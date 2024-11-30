
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/data/data_source/preference/image_preference.dart';
import 'package:ready_go_project/domain/repositories/image_local_data_repo.dart';

class ImageEntity implements ImageLocalDataRepo {
  ImagePreference get pref => ImagePreference.singleton;

  @override
  Future<List<XFile>> getArrivalImgList(int id)async {
   try{
     List<XFile> list = await pref.getArrivalImgList(id);
     return list;
   }catch(ex){
     print(ex.toString());
     rethrow;
   }
  }

  @override
  Future<List<XFile>> getDepartureImgList(int id)async {
    try{
      List<XFile> list = await pref.getDepartImgList(id);
      return list;
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateArrivalImgList(List<XFile> list, int id)async {
   try{
     await pref.updateArrivalImgList(list, id);
   }catch(ex){
     print(ex.toString());
     rethrow;
   }
  }

  @override
  Future<void> updateDepartureImgList(List<XFile> list, int id)async {
   try{
     await pref.updateDepartureImgList(list, id);
   }catch(ex){
     print(ex.toString());
     rethrow;
   }
  }


}