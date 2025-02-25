
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:ready_go_project/domain/repositories/image_repo.dart';


class PassportProvider with ChangeNotifier {
  final _getIt = GetIt.instance;
  final logger = Logger();

  XFile? get passport => _passImg;

  XFile? _passImg;

  Future<void> getPassImg() async {
    XFile? img = await _getIt.get<ImageRepo>().getPassportImg();
    if (img != null) {
      _passImg = img;
      notifyListeners();
    } else {
      logger.d("saved passport image is no exists.");
    }
  }

  Future<void> setPassImg(XFile img) async {
    int result = await _getIt.get<ImageRepo>().setPassportImg(img);
    if (result == 200) {
      _passImg = img;
      logger.d("set passport img result code : $result");
    }
    notifyListeners();
  }

  // void deleteTest(){
  //   _passImg = null;
  //   log("여권삭제 완료@");
  //   notifyListeners();
  // }
}
