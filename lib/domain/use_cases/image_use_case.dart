
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ready_go_project/domain/repositories/image_repo.dart';

import '../../data/repositories/image_local_data_repo.dart';



class ImageUseCase with ImageRepo{

  final GetIt _getIt = GetIt.I;
  final logger = Logger();
  @override
  Future<List<List<XFile>>> getImageList(int id) async {
    List<List<XFile>> imgList = [];
    try{
      final departureImg = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
      final arrivalImg = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);
      if(departureImg.isNotEmpty){
        imgList.add(departureImg.map((path) => XFile(path)).toList());
      }else{
        imgList.add([]);
      }
      if(arrivalImg.isNotEmpty){
        imgList.add(arrivalImg.map((path) => XFile(path)).toList());
      }else {
        imgList.add([]);
      }
      return imgList;
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
    return imgList;
  }

  @override
  Future<List<XFile>> addArrivalImg(XFile image, int id) async {
    try{
    List<String> list = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);
      Directory dir = await getApplicationDocumentsDirectory();
      String imgPath = "${dir.path}/arrivalImages$id${image.name}";
      // logger.d("departure to save path : $path");
      File file = File(imgPath);
      if(await file.exists()){
        logger.w("arrival image is already exists.");
      }else {
        await file.writeAsBytes(await image.readAsBytes());
        logger.d("saved ArrivalImg");
      }

      if(list.any((path) => path == imgPath)){
        logger.w("arrival image path is already exists.");
      }else{
        list.add(imgPath);
        _getIt.get<ImageLocalDataRepo>().addArrivalImage(list, id);
      }
      return list.map((path) => XFile(path)).toList();
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> addDepartureImg(XFile image, int id) async {
   try{
    List<String> list = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
     Directory dir = await getApplicationDocumentsDirectory();
     String imgPath = "${dir.path}/departureImages$id${image.name}";
     // logger.d("departure to save path : $path");
     File file = File(imgPath);
     if(await file.exists()){
       logger.w("departure image is already exists.");
     }else {
       await file.writeAsBytes(await image.readAsBytes());
       logger.d("saved DepartureImg");
     }

     if(list.any((path) => path == imgPath)){
       logger.w("departure image path is already exists.");
     }else{
       list.add(imgPath);
       _getIt.get<ImageLocalDataRepo>().addDepartureImage(list, id);
     }
     return list.map((path) => XFile(path)).toList();
   }catch(ex){
     logger.e(ex.toString());
     rethrow;
   }
  }

  @override
  Future<List<XFile>?> removeArrivalImg(XFile image, int id) async {
    try{
      List<String> list = await _getIt.get<ImageLocalDataRepo>().getArrivalImgList(id);
      String imgPath = image.path;

      File file = File(imgPath);
      if(await file.exists()){
        await file.delete();
      }else{
        logger.w("arrival image is not found.");
      }

      if(list.any((path) => path == imgPath)){
        list.remove(imgPath);
        _getIt.get<ImageLocalDataRepo>().addDepartureImage(list, id);
      }else{
        logger.w("arrival image path is not found.");
      }
      return list.map((path) => XFile(path)).toList();

    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<XFile>> removeDepartureImg(XFile image, int id) async {
    try{
      List<String> list = await _getIt.get<ImageLocalDataRepo>().getDepartureImgList(id);
      String imgPath = image.path;

      File file = File(imgPath);
      if(await file.exists()){
        await file.delete();
      }else{
        logger.w("departure image is not found.");
      }

      if(list.any((path) => path == imgPath)){
        list.remove(imgPath);
        _getIt.get<ImageLocalDataRepo>().addDepartureImage(list, id);
      }else{
        logger.w("departure image path is not found.");
      }
      return list.map((path) => XFile(path)).toList();

    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<List<XFile>>> removeAllData(int id)async{
    await _getIt.get<ImageLocalDataRepo>().removeAllData(id);
    return[[],[]];
  }

  @override
  Future<int> setPassportImg(XFile img)async{
    try {
      String? imgPath = await _getIt.get<ImageLocalDataRepo>().getPassportImg();

      Directory dir = await getApplicationDocumentsDirectory();
      String newPath = "${dir.path}/passportImage${img.name}";
      if(imgPath != null && imgPath.isNotEmpty){
        File file = File(imgPath);
        await file.delete();
      }
      File newFile = File(newPath);
      await newFile.writeAsBytes(await img.readAsBytes());

      final res = await _getIt.get<ImageLocalDataRepo>().setPassportImg(newPath);
      return res;
    } on Exception catch (e) {
      logger.w(e.toString());
      rethrow;
    }
  }

  @override
  Future<XFile?> getPassportImg()async{
    String? imgPath = await _getIt.get<ImageLocalDataRepo>().getPassportImg();
    if(imgPath != null && imgPath.isNotEmpty){
      return XFile(imgPath);
    }
    return null;
  }

}