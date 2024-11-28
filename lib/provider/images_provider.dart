import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/use_cases/image_data_use_case.dart';

class ImagesProvider with ChangeNotifier {
  late List<XFile> _departureImage;
  late List<XFile> _arrivalImage;

  List<XFile> get departureImg => _departureImage;
  List<XFile> get arrivalImg => _arrivalImage;

  Future<void> getImgList(int id)async{
    if(id != -1){
      _departureImage = await GetIt.I.get<ImageDataUseCase>().getDepartureImgList(id);
      _arrivalImage = await GetIt.I.get<ImageDataUseCase>().getArrivalImgList(id);
      if(kDebugMode){
        print("get departure: $_departureImage");
      }
      notifyListeners();
    }else {
      if(kDebugMode){
        print("plan id is -1. check the arguments");
      }
    }
  }

  Future<void> addDepartureImage(XFile image, int id)async{
    _departureImage.add(image);
    await GetIt.I.get<ImageDataUseCase>().addDepartureImg(image, id);
    notifyListeners();
  }
  Future<void> addArrivalImage(XFile image, int id)async{
    _arrivalImage.add(image);
    await GetIt.I.get<ImageDataUseCase>().addArrivalImg(image, id);
    notifyListeners();
  }
  Future<void> removeDepartureImage(XFile image, int id)async{
    _departureImage.removeWhere((e) => e == image);
    await GetIt.I.get<ImageDataUseCase>().removeDepartImg(image, id);
    notifyListeners();
  }
  Future<void> removeArrivalImage(XFile image, int id)async{
    _arrivalImage.removeWhere((e) => e == image);
    await GetIt.I.get<ImageDataUseCase>().removeArrivalImg(image, id);
    notifyListeners();
  }

}