
import 'dart:ui';

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
      print(ex.toString());
      rethrow;
    }
    return imgList;
  }



  Future<List<XFile>> addArrivalImg(XFile image, int id) async {
    List<XFile> list = [];
   try{
     list = await _getIt.get<ImageEntity>().getArrivalImgList(id);
     list.add(image);

     await _getIt.get<ImageEntity>().updateArrivalImgList(list, id);
   }catch(ex){
     print(ex.toString());
     rethrow;
   }
    return list;
  }


  Future<List<XFile>> addDepartureImg(XFile image, int id) async {
    List<XFile> list = [];
   try{
     list = await _getIt.get<ImageEntity>().getDepartureImgList(id);
     list.add(image);

     await _getIt.get<ImageEntity>().updateDepartureImgList(list, id);
   }catch(ex){
     print(ex.toString());
     rethrow;
   }
     return list;
  }


  Future<List<XFile>> removeArrivalImg(XFile image, int id) async {
    List<XFile> list = [];
    try{
      list = await _getIt.get<ImageEntity>().getArrivalImgList(id);
      list.removeWhere((img) => img == image );

      await _getIt.get<ImageEntity>().updateArrivalImgList(list, id);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
    return list;
  }


  Future<List<XFile>> removeDepartureImg(XFile image, int id) async {
    List<XFile> list = [];
    try{
      list = await _getIt.get<ImageEntity>().getDepartureImgList(id);
      list.removeWhere((img) => img == image );

      await _getIt.get<ImageEntity>().updateDepartureImgList(list, id);
    }catch(ex){
      print(ex.toString());
      rethrow;
    }
    return list;
  }

  Future<List<List<XFile>>> removeAllData(int id)async{
    await _getIt.get<ImageEntity>().removeAllData(id);
    return[[],[]];
  }

}