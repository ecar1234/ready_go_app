
import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/entities/image_entity.dart';


class ImageUseCase {

  final GetIt _getIt = GetIt.I;

  Future<List<List<XFile>>> getImageList(int id) async {
    List<List<XFile>> imgList = [];
    try{
      var departureImg = await _getIt.get<ImageEntity>().getDepartureImgList(id);
      var arrivalImg = await _getIt.get<ImageEntity>().getArrivalImgList(id);

      imgList.add(departureImg);
      imgList.add(arrivalImg);
    }catch(ex){
      log(ex.toString());
      rethrow;
    }
    return imgList;
  }



  Future<List<XFile>> addArrivalImg(XFile image, int id) async {
   try{
     var list = await _getIt.get<ImageEntity>().addArrivalImage(image, id);
     return list;
   }catch(ex){
     log(ex.toString());
     rethrow;
   }
  }


  Future<List<XFile>> addDepartureImg(XFile image, int id) async {
   try{
     var list = await _getIt.get<ImageEntity>().addDepartureImage(image, id);
     return list;
   }catch(ex){
     log(ex.toString());
     rethrow;
   }
  }


  Future<List<XFile>> removeArrivalImg(XFile image, int id) async {
    try{
      var list = await _getIt.get<ImageEntity>().removeArrivalImage(image, id);
      return list;
    }catch(ex){
      log(ex.toString());
      rethrow;
    }
  }


  Future<List<XFile>> removeDepartureImg(XFile image, int id) async {
    try{
      var list = await _getIt.get<ImageEntity>().removeDepartureImage(image, id);
      return list;
    }catch(ex){
      log(ex.toString());
      rethrow;
    }
  }

  Future<List<List<XFile>>> removeAllData(int id)async{
    await _getIt.get<ImageEntity>().removeAllData(id);
    return[[],[]];
  }

  Future<int> setPassportImg(String path)async{
    int result = await _getIt.get<ImageEntity>().setPassportImg(path);
    return result;
  }
  Future<XFile?> getPassportImg()async{
    XFile? img = await _getIt.get<ImageEntity>().getPassportImg();
    return img;
  }

}