import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:ready_go_project/domain/repositories/image_repo.dart';

class PassportProvider with ChangeNotifier {
  final _getIt = GetIt.instance;
  final logger = Logger();

  File? get passport => _passImg;

  File? _passImg;

  Future<void> getPassImg() async {
    final img = await _getIt.get<ImageRepo>().getPassportImg();
    if (img != null) {
      _passImg = img;
      notifyListeners();
    } else {
      logger.w("saved passport image is no exists.");
    }
  }

  Future<void> setPassImg(XFile img) async {
    final result = await _getIt.get<ImageRepo>().setPassportImg(img);
    if(result != null){
      _passImg = result;
    }else {
      logger.w("set passport img result code : $result");
    }

    notifyListeners();
  }

}
