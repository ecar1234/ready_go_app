import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/entities/image_entity.dart';
import 'package:ready_go_project/domain/use_cases/image_use_case.dart';

class PassportProvider with ChangeNotifier {
  final _getIt = GetIt.instance;

  XFile? get passport => _passImg;

  XFile? _passImg;

  Future<void> getPassImg() async {
    XFile? img = await _getIt.get<ImageUseCase>().getPassportImg();
    if (img != null) {
      _passImg = img;
      notifyListeners();
    } else {
      log("Get : passport image is null!!");
    }
  }

  Future<void> setPassImg(XFile img) async {
    String path = img.path;
    int result = await _getIt.get<ImageUseCase>().setPassportImg(path);
    if (result == 200) {
      _passImg = img;
      log("set passport img result code : $result");
    }
    notifyListeners();
  }

  // void deleteTest(){
  //   _passImg = null;
  //   log("여권삭제 완료@");
  //   notifyListeners();
  // }
}
